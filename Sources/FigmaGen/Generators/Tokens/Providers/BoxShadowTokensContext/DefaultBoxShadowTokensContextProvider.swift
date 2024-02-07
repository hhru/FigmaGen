import Foundation

final class DefaultBoxShadowTokensContextProvider: BoxShadowTokensContextProvider {

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

        guard let nightTokenValue = tokenValues.hhNight.first(where: { $0.name == dayTokenValue.name }) else {
            throw BoxShadowTokensContextProviderError(code: .nightValueNotFound(tokenName: dayTokenValue.name))
        }

        guard case let .boxShadow(nightValue) = nightTokenValue.type else {
            throw BoxShadowTokensContextProviderError(code: .nightValueNotFound(tokenName: dayTokenValue.name))
        }

        return BoxShadowToken(
            path: dayTokenValue.name.components(separatedBy: "."),
            dayTheme: makeTheme(value: dayValue),
            nightTheme: makeTheme(value: nightValue)
        )
    }

    // MARK: -

    func fetchBoxShadowTokensContext(from tokenValues: TokenValues) throws -> [BoxShadowToken] {
        try tokenValues.hhDay
            .compactMap { try makeBoxShadowToken(from: $0, tokenValues: tokenValues) }
            .sorted { $0.path.joined() < $1.path.joined() }
    }
}
