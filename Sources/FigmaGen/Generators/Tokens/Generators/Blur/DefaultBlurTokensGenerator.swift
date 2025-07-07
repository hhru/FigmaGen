import Foundation

struct DefaultBlurTokensGenerator: BlurTokensGenerator {

    // MARK: - Instance properties

    private let tokensResolver: TokensResolver
    private let templateRenderer: TemplateRenderer

    // MARK: - Initializers

    init(tokensResolver: TokensResolver, templateRenderer: TemplateRenderer) {
        self.tokensResolver = tokensResolver
        self.templateRenderer = templateRenderer
    }

    // MARK: - Private instance methods

    private func makeToken(
        from token: TokenValue,
        tokenValues: TokenValues
    ) throws -> BlurToken? {
        guard case .blur(let value) = token.type else {
            return nil
        }

        return BlurToken(
            path: token.name.components(separatedBy: "."),
            value: try tokensResolver.resolveValue(
                value,
                tokenValues: tokenValues,
                theme: nil
            )
        )
    }

    // MARK: - BorderRadiusTokensGenerator

    func generate(
        renderParameters: RenderParameters,
        tokenValues: TokenValues,
        themes: [Theme],
        fallbackTheme: Theme
    ) throws {
        let coreBlurs = try tokenValues.core.compactMap { value in
            try makeToken(from: value, tokenValues: tokenValues)
        }
        let semanticBlurs = try tokenValues.semantic.compactMap { value in
            try makeToken(from: value, tokenValues: tokenValues)
        }

        let semanticBlur = semanticBlurs.filter { !$0.path.contains("static") }
        let staticBlur = semanticBlurs.filter { $0.path.contains("static") }

        try templateRenderer.renderTemplate(
            renderParameters.template,
            to: renderParameters.destination,
            context: [
                "coreBlur": coreBlurs,
                "semanticBlur": semanticBlur,
                "staticBlur": staticBlur
            ]
        )
    }
}
