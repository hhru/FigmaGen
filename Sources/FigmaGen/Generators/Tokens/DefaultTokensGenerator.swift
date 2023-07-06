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

    private func evaluteValue(_ value: String) throws -> String {
        let expression = AnyExpression(value)

        do {
            return try expression.evaluate()
        } catch {
            return value
        }
    }

    private func resolveValue(_ value: String, tokenValues: TokenValues) throws -> String {
        let allTokens = tokenValues.all

        var result = value

        while let replacement = result.slice(from: "{", to: "}", includingBounds: true) {
            let referenceName = String(
                replacement
                    .removingFirst()
                    .removingLast()
            )

            guard let token = allTokens.first(where: { $0.name == referenceName }) else {
                throw TokensGeneratorError(code: .referenceNotFound(name: referenceName))
            }

            guard let value = token.type.stringValue else {
                throw TokensGeneratorError(code: .unexpectedTokenValueType(name: referenceName))
            }

            result = result.replacingOccurrences(
                of: replacement,
                with: try resolveValue(value, tokenValues: tokenValues)
            )
        }

        return try evaluteValue(result)
    }

    private func resolveColorValue(_ value: String, tokenValues: TokenValues) throws -> Color {
        let components = value
            .slice(from: "(", to: ")", includingBounds: false)?
            .components(separatedBy: ", ")

        guard let components, components.count == 2 else {
            throw TokensGeneratorError(code: .invalidRGBAColorValue(rgba: value))
        }

        let hex = components[0]
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()
            .filter { $0 != "#" }

        let alphaPercent = components[1]

        guard let alpha = Double(alphaPercent.dropLast()) else {
            throw TokensGeneratorError(code: .invalidAlphaComponent(alpha: alphaPercent))
        }

        guard hex.count == 6 else {
            throw TokensGeneratorError(code: .invalidHEXComponent(hex: hex))
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)

        return Color(
            red: Double((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: Double((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: Double(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha / 100.0
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
                    print("[\(tokenValue.name)] \(try resolveColorValue(value, tokenValues: tokenValues))")
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
