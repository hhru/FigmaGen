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

    private func makeColor(hex: String, alpha: CGFloat) throws -> Color {
        let hex = hex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()
            .filter { $0 != "#" }

        guard hex.count == 6 else {
            throw TokensGeneratorError(code: .invalidHEXComponent(hex: hex))
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)

        return Color(
            red: Double((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: Double((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }

    private func resolveColorValue(_ value: String, tokenValues: TokenValues) throws -> Color {
        if value.hasPrefix("rgba") {
            return try resolveRGBAColorValue(value, tokenValues: tokenValues)
        }

        return try makeColor(hex: value, alpha: 1.0)
    }

    // MARK: - TokensResolver

    func resolveValue(_ value: String, tokenValues: TokenValues) throws -> String {
        let allTokens = tokenValues.all

        let resolvedValue = try value.replacingOccurrences(matchingPattern: #"\{.*?\}"#) { referenceName in
            let referenceName = referenceName
                .removingFirst()
                .removingLast()

            guard let token = allTokens.first(where: { $0.name == referenceName }) else {
                throw TokensGeneratorError(code: .referenceNotFound(name: referenceName))
            }

            guard let value = token.type.stringValue else {
                throw TokensGeneratorError(code: .unexpectedTokenValueType(name: referenceName))
            }

            return try resolveValue(value, tokenValues: tokenValues)
        }

        return evaluteValue(resolvedValue)
    }

    func resolveRGBAColorValue(_ value: String, tokenValues: TokenValues) throws -> Color {
        let components = try resolveValue(value, tokenValues: tokenValues)
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

        return try makeColor(hex: hex, alpha: alpha / 100.0)
    }

    func resolveLinearGradientValue(_ value: String, tokenValues: TokenValues) throws -> LinearGradient {
        let value = try resolveValue(value, tokenValues: tokenValues)

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
            .removingFirst()
            .map { rawColorStop in
                guard let separatorRange = rawColorStop.range(of: " ", options: .backwards) else {
                    throw TokensGeneratorError(code: .failedToExtractLinearGradientParams(linearGradient: value))
                }

                let percentage = String(rawColorStop[separatorRange.upperBound...])
                let rawColor = String(rawColorStop[...separatorRange.lowerBound])
                let color = try resolveColorValue(rawColor, tokenValues: tokenValues)

                return LinearGradient.LinearColorStop(color: color, percentage: percentage)
            }

        return LinearGradient(
            angle: angle,
            colorStopList: colorStopList
        )
    }
}
