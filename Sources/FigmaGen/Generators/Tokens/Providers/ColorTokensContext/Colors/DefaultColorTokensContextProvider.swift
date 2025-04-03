import Foundation

final class DefaultColorTokensContextProvider: ColorTokensContextProvider {

    // MARK: - Instance Properties

    let tokensResolver: TokensResolver

    // MARK: - Initializers

    init(tokensResolver: TokensResolver) {
        self.tokensResolver = tokensResolver
    }

    // MARK: - Instance Methods

    private func fallbackWarning(warningPrefix: String, tokenName: String, fallbackTheme: String) {
        logger.warning("\(warningPrefix) value for token '\(tokenName)' not found, using \(fallbackTheme)", isVerbose: true)
    }

    private func resolveColorToken(
        token: TokenValue,
        theme: Theme,
        tokenValues: TokenValues
    ) throws -> ColorToken? {
        let tokens = tokenValues.tokens(for: theme)

        guard let themeToken = tokens.first(where: { $0.name == token.name }) else {
            return nil
        }

        guard case .color(let themeValue) = themeToken.type else {
            return nil
        }

        // Resolve hex color value
        let themeHexColorValue = try tokensResolver.resolveHexColorValue(
            themeValue,
            tokenValues: tokenValues,
            theme: theme
        )

        // Resolve reference
        let themeReference = try tokensResolver.resolveBaseReference(themeValue, tokenValues: tokens)

        let path = token.name.components(separatedBy: ".")

        return ColorToken(
            name: token.name,
            path: path,
            value: themeHexColorValue,
            reference: themeReference
        )
    }

    func makeColorToken(
        using token: TokenValue,
        values: TokenValues,
        theme: Theme,
        fallbackTheme: Theme
    ) throws -> ColorToken? {
        guard case .color(let dayValue) = token.type else {
            return nil
        }

        let path = token.name.components(separatedBy: ".")

        guard path[0] != "gradient" && !dayValue.contains("gradient") else {
            return nil
        }

        let fallbackToken = try resolveColorToken(token: token, theme: fallbackTheme, tokenValues: values)
        let resolvedToken = try resolveColorToken(token: token, theme: theme, tokenValues: values)

        guard let fallbackToken else {
            throw DefaultColorTokensContextProviderError.fallbackTokenNotFound(token.name)
        }

        guard let resolvedToken else {
            fallbackWarning(warningPrefix: theme.name, tokenName: token.name, fallbackTheme: fallbackTheme.name)
            return fallbackToken
        }

        return resolvedToken
    }

    // MARK: -

    func extractTokenContext(
        from tokenValues: TokenValues,
        themes: [Theme],
        fallbackTheme: Theme
    ) throws -> [TokenThemeValue<[String: Any]>] {
        return try themes.map { theme in
            let colors = try tokenValues
                .tokens(for: theme)
                .compactMap { token in
                    try makeColorToken(
                        using: token,
                        values: tokenValues,
                        theme: theme,
                        fallbackTheme: fallbackTheme
                    )
                }

            return TokenThemeValue(
                theme: theme.name,
                value: structure(tokens: colors, contextName: "colors")
            )
        }
    }
}
