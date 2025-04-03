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

    func dictionaryValue<T>(from tokens: [TokenThemeValue<T>]) -> [String: T] {
        Dictionary(uniqueKeysWithValues: tokens.map { ($0.themeName, $0.value) })
    }

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
        let gradientsContext = try gradientTokensContextProvider.extractTokenContext(
            from: tokenValues,
            themes: themes,
            fallbackTheme: fallbackTheme
        )
        let boxShadowsContext = try boxShadowsContextProvider.fetchBoxShadowTokensContext(
            from: tokenValues,
            themes: themes,
            fallbackTheme: fallbackTheme
        )

        try templateRenderer.renderTemplate(
            renderParameters.template,
            to: renderParameters.destination,
            context: [
                "themedColors": colorsContext,
                "themedBoxShadows": boxShadowsContext,
                "themedGradients": gradientsContext,
                "dictThemedColors": dictionaryValue(from: colorsContext),
                "dictThemedGradients": dictionaryValue(from: gradientsContext),
                "dictBoxShadows": dictionaryValue(from: boxShadowsContext),
                "themes": themes.map { $0.name },
                "fallbackTheme": fallbackTheme.name
            ]
        )
    }
}
