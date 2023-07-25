import Foundation

final class DefaultBoxShadowTokensGenerator: BoxShadowTokensGenerator {

    // MARK: - Instance Properties

    let tokensResolver: TokensResolver
    let templateRenderer: TemplateRenderer

    // MARK: - Initializers

    init(tokensResolver: TokensResolver, templateRenderer: TemplateRenderer) {
        self.tokensResolver = tokensResolver
        self.templateRenderer = templateRenderer
    }

    // MARK: - Instance Methods

    private func makeBoxShadowToken(from tokenValue: TokenValue, tokenValues: TokenValues) throws -> BoxShadowToken? {
        guard case let .boxShadow(value) = tokenValue.type else {
            return nil
        }

        return BoxShadowToken(
            path: tokenValue.name.components(separatedBy: "."),
            color: value.color,
            type: value.type,
            x: value.x,
            y: value.y,
            blur: value.blur,
            spread: value.spread
        )
    }

    // MARK: -

    func generate(renderParameters: RenderParameters, tokenValues: TokenValues) throws {
        let boxShadows = try tokenValues.day.compactMap { try makeBoxShadowToken(from: $0, tokenValues: tokenValues) }

        try templateRenderer.renderTemplate(
            renderParameters.template,
            to: renderParameters.destination,
            context: ["boxShadows": boxShadows]
        )
    }
}
