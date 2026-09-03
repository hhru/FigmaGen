import Foundation

// Applies a uniform scale and a vertical translation to SVG path data,
// mapping Figma coordinates into the coordinate space of an SF Symbols variant.
struct SVGPathTransformer {

    // MARK: - Nested Types

    private enum Command {

        // Number of parameters in a single parameter group of a command.
        static let arities: [Character: Int] = [
            "m": 2,
            "l": 2,
            "t": 2,
            "h": 1,
            "v": 1,
            "c": 6,
            "s": 4,
            "q": 4,
            "a": 7,
            "z": 0
        ]

        // Indexes of the large-arc and sweep flags of an elliptical arc.
        static let arcFlagIndexes = [3, 4]
    }

    private struct Reader {

        // MARK: - Type Properties

        private static let separators: Set<Character> = [" ", ",", "\n", "\r", "\t"]

        // MARK: - Instance Properties

        private let characters: [Character]

        private var index = 0

        // MARK: - Initializers

        init(_ text: String) {
            characters = Array(text)
        }

        // MARK: - Instance Methods

        private mutating func skipSeparators() {
            while index < characters.count, Self.separators.contains(characters[index]) {
                index += 1
            }
        }

        private func isDigit(at index: Int) -> Bool {
            index < characters.count && characters[index].isASCII && characters[index].isNumber
        }

        mutating func readCommand() -> Character? {
            skipSeparators()

            guard index < characters.count, characters[index].isLetter else {
                return nil
            }

            defer { index += 1 }

            return characters[index]
        }

        mutating func hasNumber() -> Bool {
            skipSeparators()

            guard index < characters.count else {
                return false
            }

            let character = characters[index]

            return isDigit(at: index) || character == "." || character == "-" || character == "+"
        }

        mutating func readNumber() -> Double? {
            skipSeparators()

            let start = index

            if index < characters.count, characters[index] == "-" || characters[index] == "+" {
                index += 1
            }

            var hasDigits = false

            while isDigit(at: index) {
                index += 1
                hasDigits = true
            }

            if index < characters.count, characters[index] == "." {
                index += 1

                while isDigit(at: index) {
                    index += 1
                    hasDigits = true
                }
            }

            guard hasDigits else {
                index = start

                return nil
            }

            if index < characters.count, characters[index] == "e" || characters[index] == "E" {
                let exponentStart = index

                index += 1

                if index < characters.count, characters[index] == "-" || characters[index] == "+" {
                    index += 1
                }

                var hasExponentDigits = false

                while isDigit(at: index) {
                    index += 1
                    hasExponentDigits = true
                }

                if !hasExponentDigits {
                    index = exponentStart
                }
            }

            return Double(String(characters[start..<index]))
        }

        // Arc flags may be written without separators, so they are always a single digit.
        mutating func readFlag() -> Double? {
            skipSeparators()

            guard index < characters.count else {
                return nil
            }

            switch characters[index] {
            case "0":
                index += 1

                return 0.0

            case "1":
                index += 1

                return 1.0

            default:
                return nil
            }
        }
    }

    // MARK: - Instance Properties

    let scale: Double
    let translationY: Double

    // MARK: - Instance Methods

    private func transformed(
        parameters: [Double],
        command: Character,
        isAbsolute: Bool
    ) -> [Double] {
        switch command {
        case "h":
            return parameters.map { $0 * scale }

        case "v":
            return parameters.map { isAbsolute ? $0 * scale + translationY : $0 * scale }

        case "a":
            var parameters = parameters

            parameters[0] *= scale
            parameters[1] *= scale
            parameters[5] *= scale
            parameters[6] = isAbsolute ? parameters[6] * scale + translationY : parameters[6] * scale

            return parameters

        default:
            return parameters.enumerated().map { index, value in
                guard index.isMultiple(of: 2) else {
                    return isAbsolute ? value * scale + translationY : value * scale
                }

                return value * scale
            }
        }
    }

    func transform(pathData: String) throws -> String {
        var reader = Reader(pathData)
        var commands: [String] = []

        while let command = reader.readCommand() {
            let lowercased = Character(command.lowercased())

            guard let arity = Command.arities[lowercased] else {
                throw SVGParserError.invalidPathData(pathData)
            }

            guard arity > 0 else {
                commands.append(String(command))

                continue
            }

            let isAbsolute = command.isUppercase
            var groups: [String] = []

            repeat {
                var parameters: [Double] = []

                for index in 0..<arity {
                    let isFlag = lowercased == "a" && Command.arcFlagIndexes.contains(index)

                    guard let parameter = isFlag ? reader.readFlag() : reader.readNumber() else {
                        throw SVGParserError.invalidPathData(pathData)
                    }

                    parameters.append(parameter)
                }

                let transformedParameters = transformed(
                    parameters: parameters,
                    command: lowercased,
                    isAbsolute: isAbsolute
                )

                groups.append(transformedParameters.map(SVGNumber.string).joined(separator: " "))
            } while reader.hasNumber()

            commands.append(String(command).appending(groups.joined(separator: " ")))
        }

        guard !commands.isEmpty else {
            throw SVGParserError.invalidPathData(pathData)
        }

        return commands.joined(separator: " ")
    }
}

// Formats coordinates the way the reference pipeline does: six decimal places without trailing zeros.
enum SVGNumber {

    // MARK: - Type Methods

    static func string(from value: Double) -> String {
        var text = String(format: "%.6f", value)

        if text.contains(".") {
            while text.hasSuffix("0") {
                text.removeLast()
            }

            if text.hasSuffix(".") {
                text.removeLast()
            }
        }

        return text == "-0" ? "0" : text
    }
}
