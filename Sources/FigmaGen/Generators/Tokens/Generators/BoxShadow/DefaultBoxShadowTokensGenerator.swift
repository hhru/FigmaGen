import Foundation

final class DefaultBoxShadowTokensGenerator: BoxShadowTokensGenerator {

    // MARK: - Instance Properties

    let boxShadowTokensContextProvider: BoxShadowTokensContextProvider
    let templateRenderer: TemplateRenderer

    // MARK: - Initializers

    init(boxShadowTokensContextProvider: BoxShadowTokensContextProvider, templateRenderer: TemplateRenderer) {
        self.boxShadowTokensContextProvider = boxShadowTokensContextProvider
        self.templateRenderer = templateRenderer
    }

    // MARK: - Instance Methods

    func generate(renderParameters: RenderParameters, tokenValues: TokenValues) throws {
        let boxShadows = try boxShadowTokensContextProvider.fetchBoxShadowTokensContext(from: tokenValues)

        try templateRenderer.renderTemplate(
            renderParameters.template,
            to: renderParameters.destination,
            context: ["boxShadows": boxShadows]
        )
    }
}
