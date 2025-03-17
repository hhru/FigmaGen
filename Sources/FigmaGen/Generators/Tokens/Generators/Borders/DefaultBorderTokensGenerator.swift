import Foundation

struct DefaultBorderTokensGenerator: BorderTokensGenerator {

    // MARK: - Instance properties

    private let tokensResolver: TokensResolver
    private let templateRenderer: TemplateRenderer

    // MARK: - Initializers

    init(tokensResolver: TokensResolver, templateRenderer: TemplateRenderer) {
        self.tokensResolver = tokensResolver
        self.templateRenderer = templateRenderer
    }

    // MARK: - Private instance methods

    private func getBorderToken(
        from token: TokenValue,
        tokens: TokenValues
    ) throws -> BorderToken? {
        guard case .border(let value) = token.type else {
            return nil
        }

        return BorderToken(
            path: token.name.components(separatedBy: "."),
            width: try tokensResolver.resolveValue(
                value.width,
                tokenValues: tokens,
                theme: .undefined
            ),
            style: value.style
        )
    }

    // MARK: - BorderTokensGenerator

    func generate(renderParameters: RenderParameters, tokenValues: TokenValues) throws {
        let semanticBorders = try tokenValues.semantic.compactMap { tokenValue in
            try getBorderToken(from: tokenValue, tokens: tokenValues)
        }

        let coreBorders = try tokenValues.core.compactMap { tokenValue in
            try getBorderToken(from: tokenValue, tokens: tokenValues)
        }

        try templateRenderer.renderTemplate(
            renderParameters.template,
            to: renderParameters.destination,
            context: [
                "coreBorders": coreBorders,
                "semanticBorders": semanticBorders
            ]
        )
    }
}
