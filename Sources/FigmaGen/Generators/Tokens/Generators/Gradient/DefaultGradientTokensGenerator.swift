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

    func generate(renderParameters: RenderParameters, tokenValues: TokenValues) throws {
        let gradientContext = try provider.extractTokenContext(from: tokenValues)

        try templateRenderer.renderTemplate(
            renderParameters.template,
            to: renderParameters.destination,
            context: ["gradients": gradientContext]
        )
    }
}
