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
        fallbackColorToken: ColorToken.Theme,
        tokenValues: TokenValues,
        theme: Theme
    ) throws -> ColorToken.Theme {
        // Resolve theme data
        let themeData: (tokenValues: [TokenValue], warningPrefix: String)
        switch theme {
        case .night:
            themeData = (tokenValues.hhNight, "Night")

        case .zpDay:
            themeData = (tokenValues.zpDay, "ZpDay")

        case .day, .undefined:
            themeData = ([], "")
        }

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

        return ColorToken.Theme(value: themeHexColorValue, reference: themeReference)
    }

    private func makeColorToken(
        dayValue: String,
        tokenName: String,
        tokenValues: TokenValues,
        path: [String]
    ) throws -> ColorToken {
        let dayColorToken = ColorToken.Theme(
            value: try tokensResolver.resolveHexColorValue(
                dayValue,
                tokenValues: tokenValues,
                theme: .day
            ),
            reference: try tokensResolver.resolveBaseReference(
                dayValue,
                tokenValues: tokenValues.hhDay
            )
        )

        let nightColorToken = try resolveColorToken(
            tokenName: tokenName,
            fallbackColorToken: dayColorToken,
            tokenValues: tokenValues,
            theme: .night
        )
        let zpDayColorToken = try resolveColorToken(
            tokenName: tokenName,
            fallbackColorToken: dayColorToken,
            tokenValues: tokenValues,
            theme: .zpDay
        )

        return ColorToken(
            dayTheme: dayColorToken,
            nightTheme: nightColorToken,
            zpDayTheme: zpDayColorToken,
            name: tokenName,
            path: path
        )
    }

    // MARK: -

    func extractTokenContext(from tokenValues: TokenValues) throws -> [String: Any] {
        let colors: [ColorToken] = try tokenValues.hhDay.compactMap { (token: TokenValue) in
            guard case .color(let dayValue) = token.type else {
                return nil
            }

            let path = token.name.components(separatedBy: ".")

            guard path[0] != "gradient" && !dayValue.contains("gradient") else {
                return nil
            }

            return try makeColorToken(
                dayValue: dayValue,
                tokenName: token.name,
                tokenValues: tokenValues,
                path: path
            )
        }

        return structure(tokens: colors, contextName: "colors")
    }
}
