import Foundation
import FigmaGenTools
import Expression

final class DefaultTokensGenerator: TokensGenerator, GenerationParametersResolving {

    // MARK: - Instance Properties

    let tokensProvider: TokensProvider

    let defaultTemplateType = RenderTemplateType.native(name: "Tokens")
    let defaultDestination = RenderDestination.console

    // MARK: - Initializers

    init(tokensProvider: TokensProvider) {
        self.tokensProvider = tokensProvider
    }

    // MARK: - Instance Methods

    private func evaluteValue(_ value: String) -> String {
        let expression = AnyExpression(value)

        do {
            return try expression.evaluate()
        } catch {
            return value
        }
    }

    private func resolveValue(_ value: String, tokenValues: TokenValues) throws -> String {
        let allTokens = tokenValues.all
        let referenceStart = "{"
        let referenceEnd = "}"

        let scanner = Scanner(string: value)

        var value = value
        var referenceRanges: [(String, Range<String.Index>)] = []

        while !scanner.isAtEnd {
            _ = scanner.scanUpToString(referenceStart)
            let startIndex = scanner.currentIndex
            _ = scanner.scanString(referenceStart)
            let referenceName = scanner.scanUpToString(referenceEnd)
            _ = scanner.scanString(referenceEnd)

            guard let referenceName else {
                continue
            }

            guard let token = allTokens.first(where: { $0.name == referenceName }) else {
                throw TokensGeneratorError(code: .referenceNotFound(name: referenceName))
            }

            guard let value = token.type.stringValue else {
                throw TokensGeneratorError(code: .unexpectedTokenValueType(name: referenceName))
            }

            referenceRanges.append(
                (try resolveValue(value, tokenValues: tokenValues), startIndex..<scanner.currentIndex)
            )
        }

        referenceRanges
            .reversed()
            .forEach { value.replaceSubrange($1, with: $0) }

        return evaluteValue(value)
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

    private func resolveRGBAColorValue(_ value: String, tokenValues: TokenValues) throws -> Color {
        let components = value
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

    private func resolveColorValue(_ value: String, tokenValues: TokenValues) throws -> Color {
        if value.hasPrefix("rgba") {
            return try resolveRGBAColorValue(value, tokenValues: tokenValues)
        }

        return try makeColor(hex: value, alpha: 1.0)
    }

    private func resolveLinearGradientValue(_ value: String, tokenValues: TokenValues) throws -> LinearGradient {
        guard let startFunctionIndex = value.firstIndex(of: "("), let endFunctionIndex = value.lastIndex(of: ")") else {
            throw TokensGeneratorError(code: .failedExtractLinearGradientParams(linearGradient: value))
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
                    throw TokensGeneratorError(code: .failedExtractLinearGradientParams(linearGradient: value))
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

    private func generate(parameters: GenerationParameters) async throws {
        let tokenValues = try await tokensProvider.fetchTokens(from: parameters.file)

        try tokenValues.all
            .compactMap { tokenValue -> (TokenValue, String)? in
                guard let value = tokenValue.type.stringValue else {
                    return nil
                }

                return (tokenValue, try resolveValue(value, tokenValues: tokenValues))
            }
            .forEach { tokenValue, value in
                if value.hasPrefix("rgba") {
                    print("[\(tokenValue.name)] \(try resolveRGBAColorValue(value, tokenValues: tokenValues))")
                } else if value.hasPrefix("linear-gradient") {
                    print("[\(tokenValue.name)] \(try resolveLinearGradientValue(value, tokenValues: tokenValues))")
                } else {
                    print("[\(tokenValue.name)] \(value)")
                }
            }

        // PORTFOLIO-22826 Генерация основных токенов
    }

    // MARK: -

    func generate(configuration: TokensConfiguration) async throws {
        let parameters = try await Task.detached(priority: .userInitiated) {
            try self.resolveGenerationParameters(from: configuration)
        }.value

        try await generate(parameters: parameters)
    }
}
