import Foundation

final class DefaultThemeTokensGenerator: ThemeTokensGenerator {

    // MARK: - Instance Properties

    let colorTokensContextProvider: ColorTokensContextProvider
    let gradientTokensContextProvider: ColorTokensContextProvider
    let boxShadowsContextProvider: BoxShadowTokensContextProvider
    let templateRenderer: TemplateRenderer

    // MARK: - Initializers

    init(
        colorTokensContextProvider: ColorTokensContextProvider,
        gradientTokensContextProvider: ColorTokensContextProvider,
        boxShadowsContextProvider: BoxShadowTokensContextProvider,
        templateRenderer: TemplateRenderer
    ) {
        self.colorTokensContextProvider = colorTokensContextProvider
        self.gradientTokensContextProvider = gradientTokensContextProvider
        self.boxShadowsContextProvider = boxShadowsContextProvider
        self.templateRenderer = templateRenderer
    }

    // MARK: - Instance Methods

    func generate(renderParameters: RenderParameters, tokenValues: TokenValues) throws {
        let colorsContext = try colorTokensContextProvider.extractTokenContext(from: tokenValues)
        let boxShadowsContext = try boxShadowsContextProvider.fetchBoxShadowTokensContext(from: tokenValues)
        let gradientsContext = try gradientTokensContextProvider.extractTokenContext(from: tokenValues)

        try templateRenderer.renderTemplate(
            renderParameters.template,
            to: renderParameters.destination,
            context: [
                "colors": colorsContext,
                "boxShadows": boxShadowsContext,
                "gradients": gradientsContext
            ]
        )
    }
}
