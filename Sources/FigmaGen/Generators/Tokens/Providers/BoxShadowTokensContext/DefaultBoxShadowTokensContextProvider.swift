import Foundation

final class DefaultBoxShadowTokensContextProvider: BoxShadowTokensContextProvider {

    // MARK: - Instance Methods

    private func makeTheme(value: TokenBoxShadowValue) -> BoxShadowToken.ShadowValue {
        BoxShadowToken.ShadowValue(
            color: value.color,
            type: value.type,
            x: value.x,
            y: value.y,
            blur: value.blur,
            spread: value.spread
        )
    }

    private func makeBoxShadowToken(
        from fallbackTokenValue: TokenValue,
        tokenValues: TokenValues,
        themes: [Theme],
        fallbackTheme: Theme
    ) throws -> BoxShadowToken? {
        guard case let .boxShadow(fallbackValue) = fallbackTokenValue.type else {
            return nil
        }

        let shadows = try themes.map { theme in
            guard theme != fallbackTheme else {
                return (theme.key, makeTheme(value: fallbackValue))
            }

            guard let nightTokenValue = tokenValues.tokens(for: theme).first(where: { $0.name == fallbackTokenValue.name }) else {
                throw BoxShadowTokensContextProviderError(code: .valueNotFound(tokenName: fallbackTokenValue.name, theme: theme.key))
            }

            guard case let .boxShadow(boxShadowValue) = nightTokenValue.type else {
                throw BoxShadowTokensContextProviderError(code: .valueNotFound(tokenName: fallbackTokenValue.name, theme: theme.key))
            }

            return (theme.key, makeTheme(value: boxShadowValue))
        }


        return BoxShadowToken(
            path: fallbackTokenValue.name.components(separatedBy: "."),
            themedValue: Dictionary(uniqueKeysWithValues: shadows)
        )
    }

    // MARK: -

    func fetchBoxShadowTokensContext(
        from tokenValues: TokenValues,
        themes: [Theme],
        fallbackTheme: Theme
    ) throws -> [BoxShadowToken] {
        try tokenValues.tokens(for: fallbackTheme)
            .compactMap {
                try makeBoxShadowToken(
                    from: $0,
                    tokenValues: tokenValues,
                    themes: themes,
                    fallbackTheme: fallbackTheme
                )
            }
            .sorted { $0.path.joined() < $1.path.joined() }
    }
}
