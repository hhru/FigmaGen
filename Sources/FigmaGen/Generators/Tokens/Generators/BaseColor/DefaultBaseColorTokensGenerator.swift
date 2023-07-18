import Foundation

final class DefaultBaseColorTokensGenerator: BaseColorTokensGenerator {

    // MARK: - Instance Properties

    let tokensResolver: TokensResolver
    let templateRenderer: TemplateRenderer

    // MARK: - Initializers

    init(tokensResolver: TokensResolver, templateRenderer: TemplateRenderer) {
        self.tokensResolver = tokensResolver
        self.templateRenderer = templateRenderer
    }

    // MARK: - Instance Methods

    private func makeBaseColorToken(from token: TokenValue, tokenValues: TokenValues) throws -> BaseColorToken? {
        guard case .color(let value) = token.type else {
            return nil
        }

        return BaseColorToken(
            path: token.name.components(separatedBy: "."),
            value: try tokensResolver.resolveHexColorValue(value, tokenValues: tokenValues)
        )
    }

    // MARK: -

    func generate(renderParameters: RenderParameters, tokenValues: TokenValues) throws {
        let colors = try tokenValues.colors.compactMap { try makeBaseColorToken(from: $0, tokenValues: tokenValues) }

        try templateRenderer.renderTemplate(
            renderParameters.template,
            to: renderParameters.destination,
            context: ["colors": colors]
        )
    }
}
