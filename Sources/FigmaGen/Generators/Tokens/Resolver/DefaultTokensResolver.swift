import Foundation
import Expression

final class DefaultTokensResolver: TokensResolver {

    // MARK: - Instance Methods

    private func evaluteValue(_ value: String) -> String {
        let expression = AnyExpression(value)

        do {
            return try expression.evaluate()
        } catch {
            return value
        }
    }

    private func colorComponent(from string: String, start: Int, length: Int) -> Double {
        let startIndex = string.index(string.startIndex, offsetBy: start)
        let endIndex = string.index(startIndex, offsetBy: length)
        let substring = string[startIndex..<endIndex]
        let fullHexString = (length == 2) ? String(substring) : "\(substring)\(substring)"

        var hexComponent: UInt64 = 0

        guard Scanner(string: fullHexString).scanHexInt64(&hexComponent) else {
            return .zero
        }

        let hexFloat = CGFloat(hexComponent)

        return hexFloat / 255.0
    }

    private func makeColor(hex: String, alpha: CGFloat, tokenName: String) throws -> Color {
        let hex = hex
            .replacingOccurrences(of: "#", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()

        switch hex.count {
        case .rgb:
            return Color(
                red: colorComponent(from: hex, start: 0, length: 1),
                green: colorComponent(from: hex, start: 1, length: 1),
                blue: colorComponent(from: hex, start: 2, length: 1),
                alpha: alpha
            )

        case .rrggbb:
            return Color(
                red: colorComponent(from: hex, start: 0, length: 2),
                green: colorComponent(from: hex, start: 2, length: 2),
                blue: colorComponent(from: hex, start: 4, length: 2),
                alpha: alpha
            )

        default:
            throw TokensGeneratorError(code: .invalidHEXComponent(hex: hex, tokenName: tokenName))
        }
    }

    private func resolveColorValue(_ value: String, tokenValues: TokenValues, theme: Theme) throws -> Color {
        if value.hasPrefix("rgba") {
            return try resolveRGBAColorValue(value, tokenValues: tokenValues, theme: theme)
        }

        return try makeColor(hex: value, alpha: 1.0, tokenName: value)
    }

    // MARK: - TokensResolver

    func resolveValue(_ value: String, tokenValues: TokenValues, theme: Theme) throws -> String {
        let themeTokens = tokenValues.getThemeTokenValues(theme: theme)

        let resolvedValue = try value.replacingOccurrences(matchingPattern: #"\{.*?\}"#) { referenceName in
            let referenceName = String(
                referenceName
                    .dropFirst()
                    .dropLast()
            )

            guard let token = themeTokens.first(where: { $0.name == referenceName }) else {
                throw TokensGeneratorError(code: .referenceNotFound(name: referenceName))
            }

            guard let value = token.type.stringValue else {
                throw TokensGeneratorError(code: .unexpectedTokenValueType(name: referenceName))
            }

            return try resolveValue(value, tokenValues: tokenValues, theme: theme)
        }

        return evaluteValue(resolvedValue)
    }

    func resolveRGBAColorValue(_ value: String, tokenValues: TokenValues, theme: Theme) throws -> Color {
        let components = try resolveValue(value, tokenValues: tokenValues, theme: theme)
            .slice(from: "(", to: ")", includingBounds: false)?
            .components(separatedBy: ", ")

        guard let components, components.count == 2 else {
            throw TokensGeneratorError(code: .invalidRGBAColorValue(rgba: value))
        }

        let hex = components[0]
        let alphaPercent = components[1]

        guard let alpha = Double(alphaPercent.dropLast()) else {
            throw TokensGeneratorError(code: .invalidAlphaComponent(alpha: alphaPercent))
        }

        return try makeColor(hex: hex, alpha: alpha / 100.0, tokenName: value)
    }

    func resolveHexColorValue(_ value: String, tokenValues: TokenValues, theme: Theme) throws -> String {
        let resolvedValue = try resolveValue(value, tokenValues: tokenValues, theme: theme)

        if resolvedValue.hasPrefix("#") {
            return resolvedValue
        }
        return try resolveColorValue(resolvedValue, tokenValues: tokenValues, theme: theme).hexString
    }

    func resolveLinearGradientValue(_ value: String, tokenValues: TokenValues, theme: Theme) throws -> LinearGradient {
        let value = try resolveValue(value, tokenValues: tokenValues, theme: theme)

        guard let startFunctionIndex = value.firstIndex(of: "("), let endFunctionIndex = value.lastIndex(of: ")") else {
            throw TokensGeneratorError(code: .failedToExtractLinearGradientParams(linearGradient: value))
        }

        let rawParams = value[value.index(after: startFunctionIndex)..<endFunctionIndex]
        let pattern = #",(?![^(]*\))(?![^"']*["'](?:[^"']*["'][^"']*["'])*[^"']*$)"#

        let params = try String(rawParams)
            .split(usingRegex: pattern)
            .map { $0.trimmingCharacters(in: .whitespaces) }

        let angle = params[0]

        let colorStopList = try params
            .dropFirst()
            .map { rawColorStop in
                guard let separatorRange = rawColorStop.range(of: " ", options: .backwards) else {
                    throw TokensGeneratorError(code: .failedToExtractLinearGradientParams(linearGradient: value))
                }

                let percentage = String(rawColorStop[separatorRange.upperBound...])
                let rawColor = String(rawColorStop[...separatorRange.lowerBound])
                let color = try resolveColorValue(rawColor, tokenValues: tokenValues, theme: theme)

                return LinearGradient.LinearColorStop(color: color, percentage: percentage)
            }

        return LinearGradient(
            angle: angle,
            colorStopList: colorStopList
        )
    }
}

extension Int {

    // MARK: - Type Properties

    fileprivate static let rgb = 3
    fileprivate static let rrggbb = 6
}
