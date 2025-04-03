import Foundation

struct DefaultGradientTokensGenerator: GradientTokensGenerator {

    // MARK: - Instance properties

    private let templateRenderer: TemplateRenderer
    private let provider: ColorTokensContextProvider

    init(
        templateRenderer: TemplateRenderer,
        gradientProvider: ColorTokensContextProvider
    ) {
        self.templateRenderer = templateRenderer
        self.provider = gradientProvider
    }

    // MARK: - GradientTokensGenerator

    func generate(
        renderParameters: RenderParameters,
        tokenValues: TokenValues,
        themes: [Theme],
        fallbackTheme: Theme
    ) throws {
        let gradientsContext = try provider.extractTokenContext(
            from: tokenValues,
            themes: themes,
            fallbackTheme: fallbackTheme
        )

        let dictGradientsContext = Dictionary(
            uniqueKeysWithValues: gradientsContext
                .map {
                    ($0.themeName, $0.value)
                }
        )

        try templateRenderer.renderTemplate(
            renderParameters.template,
            to: renderParameters.destination,
            context: [
                "themedGradients": gradientsContext,
                "dictThemedGradients": dictGradientsContext,
                "themes": themes,
                "fallbackTheme": fallbackTheme.name
            ]
        )
    }
}
