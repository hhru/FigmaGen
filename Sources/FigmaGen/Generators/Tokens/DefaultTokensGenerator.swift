import Foundation
import FigmaGenTools

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

    private func generate(parameters: GenerationParameters) async throws {
        let tokenValues = try await tokensProvider.fetchTokens(from: parameters.file)

        print(tokenValues)

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
