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

    func generate(
        renderParameters: RenderParameters,
        tokenValues: TokenValues,
        themes: [Theme],
        fallbackTheme: Theme
    ) throws {
        let colorsContext = try colorTokensContextProvider.extractTokenContext(
            from: tokenValues,
            themes: themes,
            fallbackTheme: fallbackTheme
        )

        let dictColorsContext = Dictionary(
            uniqueKeysWithValues: colorsContext
                .map {
                    ($0.themeName, $0.value)
                }
        )

        try templateRenderer.renderTemplate(
            renderParameters.template,
            to: renderParameters.destination,
            context: [
                "themedColors": colorsContext,
                "dictThemedColors": dictColorsContext,
                "themes": themes,
                "fallbackTheme": fallbackTheme.name
            ]
        )
    }
}
