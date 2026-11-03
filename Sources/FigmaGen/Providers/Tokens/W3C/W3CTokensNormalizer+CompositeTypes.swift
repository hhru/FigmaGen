import Foundation

// MARK: - Composite Types

extension W3CTokensNormalizer {

    // MARK: - Instance Methods

    func makeCompositeTokenValueType(from leaf: Leaf) throws -> TokenValueType? {
        let value = leaf.value

        switch leaf.type {
        case "duration", "animationTime":
            return .animationTime(value: TokenAnimationTimeValue(duration: try milliseconds(value, leaf)))

        case "cubicBezier", "animationEaseBase":
            return .animationEaseBase(value: try cubicBezier(value, leaf))

        case "easing":
            return try easing(value, leaf)

        case "transition", "animation":
            return .animation(value: try transition(value, leaf))

        case "shadow", "boxShadow":
            return try shadow(value, leaf)

        case "border":
            return .border(value: try decode(value, leaf))

        case "typography", "template", "composition":
            return .typography(value: try decode(value, leaf))

        default:
            return nil
        }
    }

    /// `"100ms"` → `"100"`, `"0.1s"` → `"100"`, `100` → `"100"`.
    private func milliseconds(_ value: W3CTokenJSON, _ leaf: Leaf) throws -> String {
        let string = try string(value, leaf).trimmingCharacters(in: .whitespaces)

        if string.hasSuffix("ms") {
            return String(string.dropLast(2)).trimmingCharacters(in: .whitespaces)
        }

        if string.hasSuffix("s"), let seconds = Double(string.dropLast()) {
            return String(seconds * 1000)
        }

        return string
    }

    /// `[0.4, 0.24, 0, 1]` или `"cubic-bezier(0.4, 0.24, 0, 1)"`.
    private func cubicBezier(_ value: W3CTokenJSON, _ leaf: Leaf) throws -> TokenAnimationEaseBaseValue {
        let points = try value.arrayValue?.map { try string($0, leaf) }
            ?? functionArguments(of: "cubic-bezier", in: try string(value, leaf))

        guard let points, points.count == 4 else {
            throw invalidValueError(leaf)
        }

        return TokenAnimationEaseBaseValue(x1: points[0], y1: points[1], x2: points[2], y2: points[3])
    }

    /// `"spring(mass, stiffness, damping, velocity)"` или `"cubic-bezier(...)"`.
    private func easing(_ value: W3CTokenJSON, _ leaf: Leaf) throws -> TokenValueType {
        guard
            let string = value.stringValue,
            let arguments = functionArguments(of: "spring", in: string)
        else {
            return .animationEaseBase(value: try cubicBezier(value, leaf))
        }

        guard (3...4).contains(arguments.count) else {
            throw invalidValueError(leaf)
        }

        return .animationEaseSpring(
            value: TokenAnimationEaseSpringValue(
                stiffness: arguments[1],
                damping: arguments[2],
                mass: arguments[0],
                velocity: arguments.count == 4 ? arguments[3] : nil
            )
        )
    }

    /// `{duration: "100ms", delay: "0ms", timingFunction | easing: "cubic-bezier(...)" | [...]}`.
    private func transition(_ value: W3CTokenJSON, _ leaf: Leaf) throws -> TokenAnimationValue {
        guard
            let object = value.objectValue,
            let duration = object["duration"],
            let easing = object["timingFunction"] ?? object["easing"]
        else {
            throw invalidValueError(leaf)
        }

        let bezier = try cubicBezier(easing, leaf)

        return TokenAnimationValue(
            x1: bezier.x1,
            y1: bezier.y1,
            x2: bezier.x2,
            y2: bezier.y2,
            duration: try milliseconds(duration, leaf),
            delay: try object["delay"].map { try milliseconds($0, leaf) }
        )
    }

    private func shadow(_ value: W3CTokenJSON, _ leaf: Leaf) throws -> TokenValueType {
        if let shadows = value.arrayValue {
            guard shadows.count == 1 else {
                throw TokensProviderError(code: .multipleShadowsNotSupported(name: leaf.name, count: shadows.count))
            }

            return try shadow(shadows[0], leaf)
        }

        guard var object = value.objectValue else {
            throw invalidValueError(leaf)
        }

        // В W3C тип тени задается флагом `inset`, в Tokens Studio — полем `type`
        if object["type"] == nil {
            object["type"] = .string(object["inset"] == .bool(true) ? "innerShadow" : "dropShadow")
        }

        let shadow: TokenBoxShadowValue = try decode(
            .object(object),
            leaf,
            renamingKeys: ["offsetX": "x", "offsetY": "y"]
        )

        return .boxShadow(value: shadow)
    }

    // MARK: - Helpers

    /// Аргументы функции вида `name(a, b, c)` или `name(a b c)`.
    private func functionArguments(of function: String, in string: String) -> [String]? {
        let string = string.trimmingCharacters(in: .whitespaces)

        guard
            string.hasPrefix("\(function)("),
            string.hasSuffix(")")
        else {
            return nil
        }

        return string
            .dropFirst(function.count + 1)
            .dropLast()
            .components(separatedBy: CharacterSet(charactersIn: ", "))
            .filter { !$0.isEmpty }
    }

    /// Декодирует составное значение, приводя скалярные поля к строкам.
    private func decode<T: Decodable>(
        _ value: W3CTokenJSON,
        _ leaf: Leaf,
        renamingKeys: [String: String] = [:]
    ) throws -> T {
        guard let object = value.objectValue else {
            throw invalidValueError(leaf)
        }

        let scalars = object.compactMapValues { fieldValue($0) }
        var fields = scalars.filter { renamingKeys[$0.key] == nil }

        for (key, alias) in renamingKeys {
            guard let value = scalars[key] else {
                continue
            }

            if let ignored = fields[alias] {
                warn("Token '\(leaf.name)' contains both '\(key)' and '\(alias)': '\(key)' = \(value) is used, '\(alias)' = \(ignored) is ignored")
            }

            fields[alias] = value
        }

        do {
            return try JSONDecoder().decode(T.self, from: JSONEncoder().encode(fields))
        } catch let DecodingError.keyNotFound(key, _) {
            throw TokensProviderError(code: .invalidTokenField(name: leaf.name, field: key.stringValue))
        } catch {
            throw invalidValueError(leaf)
        }
    }

    /// Скаляр — строкой, массив строк — через `", "`: `["HH Sans", "Helvetica"]` → `"HH Sans, Helvetica"`.
    private func fieldValue(_ value: W3CTokenJSON) -> String? {
        guard let array = value.arrayValue else {
            return value.stringValue
        }

        let strings = array.compactMap { $0.stringValue }

        return strings.count == array.count ? strings.joined(separator: ", ") : nil
    }
}
