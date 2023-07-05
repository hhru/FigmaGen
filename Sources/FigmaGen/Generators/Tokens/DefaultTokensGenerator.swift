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
        let expression = Expression(value)

        do {
            return try String(expression.evaluate())
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

        return evaluteValue(result)
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
                print("[\(tokenValue.name)] \(value)")
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
