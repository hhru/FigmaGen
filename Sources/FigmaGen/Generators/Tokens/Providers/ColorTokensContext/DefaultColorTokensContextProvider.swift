import Foundation

final class DefaultColorTokensContextProvider: ColorTokensContextProvider {

    // MARK: - Instance Properties

    let tokensResolver: TokensResolver

    // MARK: - Initializers

    init(tokensResolver: TokensResolver) {
        self.tokensResolver = tokensResolver
    }

    // MARK: - Instance Methods

    private func fallbackWarning(warningPrefix: String, tokenName: String) {
        logger.warning("\(warningPrefix) value for token '\(tokenName)' not found, using day value.")
    }

    private func resolveColorToken(
        tokenName: String,
        fallbackColorToken: ColorToken.ColorValue,
        tokenValues: TokenValues,
        theme: Theme
    ) throws -> ColorToken.ColorValue {
        let tokens = tokenValues.tokens(for: theme)
        let themeData: (tokenValues: [TokenValue], warningPrefix: String) = (tokens, theme.key)

        // Resolve token and value
        guard let themeToken = themeData.tokenValues.first(where: { $0.name == tokenName }) else {
            fallbackWarning(warningPrefix: themeData.warningPrefix, tokenName: tokenName)
            return fallbackColorToken
        }

        guard case .color(let themeValue) = themeToken.type else {
            fallbackWarning(warningPrefix: themeData.warningPrefix, tokenName: tokenName)
            return fallbackColorToken
        }

        // Resolve hex color value
        let themeHexColorValue = try tokensResolver.resolveHexColorValue(
            themeValue,
            tokenValues: tokenValues,
            theme: theme
        )

        // Resolve reference
        let themeReference = try tokensResolver.resolveBaseReference(themeValue, tokenValues: themeData.tokenValues)

        return ColorToken.ColorValue(value: themeHexColorValue, reference: themeReference)
    }

    private func makeColorToken(
        baseTokenValue: String,
        tokenName: String,
        tokenValues: TokenValues,
        path: [String],
        themes: [Theme],
        fallbackTheme: Theme
    ) throws -> ColorToken {
        let fallbackColorToken = ColorToken.ColorValue(
            value: try tokensResolver.resolveHexColorValue(
                baseTokenValue,
                tokenValues: tokenValues,
                theme: fallbackTheme
            ),
            reference: try tokensResolver.resolveBaseReference(
                baseTokenValue,
                tokenValues: tokenValues.tokens(for: fallbackTheme)
            )
        )

        let colors = try themes.map { theme in
            guard theme != fallbackTheme else {
                return (theme, fallbackColorToken)
            }

            let token = try resolveColorToken(
                tokenName: tokenName,
                fallbackColorToken: fallbackColorToken,
                tokenValues: tokenValues,
                theme: theme
            )

            return (theme, token)
        }

        return ColorToken(
            name: tokenName,
            path: path,
            themedValue: [:]
        )
    }

    // MARK: -

    func extractTokenContext(from tokenValues: TokenValues, themes: [Theme], fallbackTheme: Theme) throws -> [String: Any] {
        let colors: [ColorToken] = try tokenValues.tokens(for: fallbackTheme).compactMap { (token: TokenValue) in
            guard case .color(let dayValue) = token.type else {
                return nil
            }

            let path = token.name.components(separatedBy: ".")

            guard path[0] != "gradient" && !dayValue.contains("gradient") else {
                return nil
            }

            return try makeColorToken(
                baseTokenValue: dayValue,
                tokenName: token.name,
                tokenValues: tokenValues,
                path: path,
                themes: themes,
                fallbackTheme: fallbackTheme
            )
        }

        return structure(tokens: colors, contextName: "colors")
    }
}
