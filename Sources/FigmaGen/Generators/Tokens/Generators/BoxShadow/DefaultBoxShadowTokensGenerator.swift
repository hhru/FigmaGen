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

    private func makeTheme(value: TokenBoxShadowValue) -> BoxShadowToken.Theme {
        BoxShadowToken.Theme(
            color: value.color,
            type: value.type,
            x: value.x,
            y: value.y,
            blur: value.blur,
            spread: value.spread
        )
    }

    private func makeBoxShadowToken(
        from dayTokenValue: TokenValue,
        tokenValues: TokenValues
    ) throws -> BoxShadowToken? {
        guard case let .boxShadow(dayValue) = dayTokenValue.type else {
            return nil
        }

        guard let nightTokenValue = tokenValues.night.first(where: { $0.name == dayTokenValue.name }) else {
            throw BoxShadowTokensGeneratorError(code: .nightValueNotFound(tokenName: dayTokenValue.name))
        }

        guard case let .boxShadow(nightValue) = nightTokenValue.type else {
            throw BoxShadowTokensGeneratorError(code: .nightValueNotFound(tokenName: dayTokenValue.name))
        }

        return BoxShadowToken(
            path: dayTokenValue.name.components(separatedBy: "."),
            dayTheme: makeTheme(value: dayValue),
            nightTheme: makeTheme(value: nightValue)
        )
    }

    // MARK: -

    func generate(renderParameters: RenderParameters, tokenValues: TokenValues) throws {
        let boxShadows = try tokenValues.day
            .compactMap { try makeBoxShadowToken(from: $0, tokenValues: tokenValues) }
            .sorted { $0.path.joined() < $1.path.joined() }

        try templateRenderer.renderTemplate(
            renderParameters.template,
            to: renderParameters.destination,
            context: ["boxShadows": boxShadows]
        )
    }
}
