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
        let gradientContext = try provider.extractTokenContext(
            from: tokenValues,
            themes: themes,
            fallbackTheme: fallbackTheme
        )

        try templateRenderer.renderTemplate(
            renderParameters.template,
            to: renderParameters.destination,
            context: [
                "gradients": gradientContext,
                "themes": themes.map { $0.key }
            ]
        )
    }
}
