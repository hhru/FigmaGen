import Foundation

final class DefaultSpacingTokensGenerator: SpacingTokensGenerator {

    // MARK: - Instance Properties

    let tokensResolver: TokensResolver
    let templateRenderer: TemplateRenderer

    // MARK: - Initializers

    init(tokensResolver: TokensResolver, templateRenderer: TemplateRenderer) {
        self.tokensResolver = tokensResolver
        self.templateRenderer = templateRenderer
    }

    // MARK: - Instance Methods

    private func makeSpacingToken(from token: TokenValue, tokenValues: TokenValues) throws -> SpacingToken? {
        guard case .spacing(let value) = token.type else {
            return nil
        }

        return SpacingToken(
            path: token.name.components(separatedBy: "."),
            value: try tokensResolver.resolveValue(value, tokenValues: tokenValues)
        )
    }

    // MARK: -

    func generate(renderParameters: RenderParameters, tokenValues: TokenValues) throws {
        let spacings = try tokenValues.semantic.compactMap { try makeSpacingToken(from: $0, tokenValues: tokenValues) }

        try templateRenderer.renderTemplate(
            renderParameters.template,
            to: renderParameters.destination,
            context: ["spacings": spacings]
        )
    }
}
