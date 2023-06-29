import Foundation
import FigmaGenTools

final class DefaultTokensGenerator: TokensGenerator, GenerationParametersResolving {

    // MARK: - Instance Properties

    let defaultTemplateType = RenderTemplateType.native(name: "Tokens")
    let defaultDestination = RenderDestination.console

    // MARK: - Instance Methods

    private func generate(parameters: GenerationParameters) async throws {
        // TODO: MOB-31417 Получение токенов из Figma
        // TODO: PORTFOLIO-22826 Генерация основных токенов
    }

    // MARK: -

    func generate(configuration: TokensConfiguration) async throws {
        let parameters = try await Task.detached(priority: .userInitiated) {
            try self.resolveGenerationParameters(from: configuration)
        }.value

        try await generate(parameters: parameters)
    }
}
