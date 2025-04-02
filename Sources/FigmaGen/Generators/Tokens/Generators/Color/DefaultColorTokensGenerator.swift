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

    func generate(renderParameters: RenderParameters, tokenValues: TokenValues, themes: [Theme], fallbackTheme: Theme) throws {
        let context = try colorTokensContextProvider.extractTokenContext(
            from: tokenValues,
            themes: themes,
            fallbackTheme: fallbackTheme
        )

        try templateRenderer.renderTemplate(
            renderParameters.template,
            to: renderParameters.destination,
            context: [
                "colors": context,
                "themes": themes.map { $0.key }
            ]
        )
    }
}
