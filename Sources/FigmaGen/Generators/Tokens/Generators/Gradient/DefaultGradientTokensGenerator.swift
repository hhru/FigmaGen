import Foundation

struct DefaultGradientTokensGenerator: GradientTokensGenerator {

    // MARK: - Instance properties

    private let templateRenderer: TemplateRenderer
    private let provider: GradientTokensContextProvider

    init(
        templateRenderer: TemplateRenderer,
        provider: GradientTokensContextProvider
    ) {
        self.templateRenderer = templateRenderer
        self.provider = provider
    }

    // MARK: - GradientTokensGenerator

    func generate(renderParameters: RenderParameters, tokenValues: TokenValues) throws {
        let gradientContext = try provider.extractContext(from: tokenValues)

        try templateRenderer.renderTemplate(
            renderParameters.template,
            to: renderParameters.destination,
            context: ["gradient": gradientContext]
        )
    }
}
