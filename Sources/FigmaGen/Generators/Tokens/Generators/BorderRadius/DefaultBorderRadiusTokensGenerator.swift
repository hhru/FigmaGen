import Foundation

struct DefaultBorderRadiusTokensGenerator: BorderRadiusTokensGenerator {

    // MARK: - Instance properties

    private let tokensResolver: TokensResolver
    private let templateRenderer: TemplateRenderer

    // MARK: - Initializers

    init(tokensResolver: TokensResolver, templateRenderer: TemplateRenderer) {
        self.tokensResolver = tokensResolver
        self.templateRenderer = templateRenderer
    }

    // MARK: - Private instance methods

    private func makeBorderRadiusToken(
        from token: TokenValue,
        tokenValues: TokenValues
    ) throws -> BorderRadiusToken? {
        guard case .borderRadius(let value) = token.type else {
            return nil
        }

        return BorderRadiusToken(
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
        let coreBorderRadius = try tokenValues.core.compactMap { value in
            try makeBorderRadiusToken(from: value, tokenValues: tokenValues)
        }
        let semanticBorderRadiuses = try tokenValues.semantic.compactMap { value in
            try makeBorderRadiusToken(from: value, tokenValues: tokenValues)
        }

        let semanticBorderRadius = semanticBorderRadiuses.filter { !$0.path.contains("static") }
        let staticBorderRadius = semanticBorderRadiuses.filter { $0.path.contains("static") }

        try templateRenderer.renderTemplate(
            renderParameters.template,
            to: renderParameters.destination,
            context: [
                "coreBorderRadius": coreBorderRadius,
                "semanticBorderRadius": semanticBorderRadius,
                "staticBorderRadius": staticBorderRadius
            ]
        )
    }
}
