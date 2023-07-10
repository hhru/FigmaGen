import Foundation
import FigmaGenTools
import Expression

final class DefaultTokensGenerator: TokensGenerator, GenerationParametersResolving {

    // MARK: - Instance Properties

    let tokensProvider: TokensProvider
    let tokensResolver: TokensResolver

    let defaultTemplateType = RenderTemplateType.native(name: "Tokens")
    let defaultDestination = RenderDestination.console

    // MARK: - Initializers

    init(tokensProvider: TokensProvider, tokensResolver: TokensResolver) {
        self.tokensProvider = tokensProvider
        self.tokensResolver = tokensResolver
    }

    // MARK: - Instance Methods

    private func generate(parameters: GenerationParameters) async throws {
        let tokenValues = try await tokensProvider.fetchTokens(from: parameters.file)

        try tokenValues.all
            .compactMap { tokenValue -> (TokenValue, String)? in
                guard let value = tokenValue.type.stringValue else {
                    return nil
                }

                return (tokenValue, try tokensResolver.resolveValue(value, tokenValues: tokenValues))
            }
            .forEach { tokenValue, value in
                if value.hasPrefix("rgba") {
                    print(
                        "[\(tokenValue.name)] " +
                        "\(try tokensResolver.resolveRGBAColorValue(value, tokenValues: tokenValues))"
                    )
                } else if value.hasPrefix("linear-gradient") {
                    print(
                        "[\(tokenValue.name)] " +
                        "\(try tokensResolver.resolveLinearGradientValue(value, tokenValues: tokenValues))"
                    )
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
