import Foundation

final class DefaultColorTokensGenerator: ColorTokensGenerator {

    // MARK: - Instance Properties

    let templateRenderer: TemplateRenderer
    let colorTokensContextProvider: ColorTokensContextProvider

    // MARK: - Initializers

    init(
        templateRenderer: TemplateRenderer,
        colorTokensContextProvider: ColorTokensContextProvider
    ) {
        self.templateRenderer = templateRenderer
        self.colorTokensContextProvider = colorTokensContextProvider
    }

    // MARK: - Instance Methods

    func generate(renderParameters: RenderParameters, tokenValues: TokenValues) throws {
        let context = try colorTokensContextProvider.fetchColorTokensContext(from: tokenValues)

        try templateRenderer.renderTemplate(
            renderParameters.template,
            to: renderParameters.destination,
            context: ["colors": context]
        )
    }
}
