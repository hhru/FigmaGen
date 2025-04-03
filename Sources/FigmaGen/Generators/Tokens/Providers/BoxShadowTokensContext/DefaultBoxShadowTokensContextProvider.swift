import Foundation

final class DefaultBoxShadowTokensContextProvider: BoxShadowTokensContextProvider {

    // MARK: - Instance Methods

    private func resolveBoxShadowToken(
        token: TokenValue,
        values: TokenValues,
        theme: Theme
    ) throws -> BoxShadowToken? {
        let tokens = values.tokens(for: theme)

        guard let themedToken = tokens.first(where: { $0.name == token.name }) else {
            return nil
        }

        guard case let .boxShadow(boxShadowValue) = themedToken.type else {
            return nil
        }

        return BoxShadowToken(
            path: token.name.components(separatedBy: "."),
            color: boxShadowValue.color,
            type: boxShadowValue.type,
            x: boxShadowValue.x,
            y: boxShadowValue.y,
            blur: boxShadowValue.blur,
            spread: boxShadowValue.spread
        )
    }

    private func makeBoxShadowToken(
        from token: TokenValue,
        tokenValues: TokenValues,
        theme: Theme,
        fallbackTheme: Theme
    ) throws -> BoxShadowToken? {
        guard case .boxShadow(_) = token.type else {
            return nil
        }

        let fallbackToken = try resolveBoxShadowToken(token: token, values: tokenValues, theme: fallbackTheme)
        let resolvedToken = try resolveBoxShadowToken(token: token, values: tokenValues, theme: theme)

        guard let fallbackToken else {
            logger.warning("Fallback token not found for \(token.name)", isVerbose: true)
            return nil
        }

        if resolvedToken.isNil {
            logger.warning(
                "\(theme.name) value for token '\(token.name)' not found, using \(fallbackTheme.name)",
                isVerbose: true
            )
        }

        return resolvedToken ?? fallbackToken
    }

    // MARK: -

    func fetchBoxShadowTokensContext(
        from tokenValues: TokenValues,
        themes: [Theme],
        fallbackTheme: Theme
    ) throws -> [TokenThemeValue<[BoxShadowToken]>] {
        return try themes.map { theme in
            let shadows = try tokenValues.tokens(for: fallbackTheme)
                .compactMap {
                    try makeBoxShadowToken(from: $0, tokenValues: tokenValues, theme: theme, fallbackTheme: fallbackTheme)
                }
                .sorted { $0.path.joined() < $1.path.joined() }

            return TokenThemeValue(theme: theme.name, value: shadows)
        }
    }
}
