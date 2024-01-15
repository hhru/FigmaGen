import Foundation

final class DefaultColorTokensContextProvider: ColorTokensContextProvider {

    // MARK: - Instance Properties

    let tokensResolver: TokensResolver

    // MARK: - Initializers

    init(tokensResolver: TokensResolver) {
        self.tokensResolver = tokensResolver
    }

    // MARK: - Instance Methods

    private func fallbackWarning(tokenName: String) {
        logger.warning("Night value for token '\(tokenName)' not found, using day value.")
    }

    private func resolveNightValue(
        tokenName: String,
        fallbackValue: String,
        tokenValues: TokenValues
    ) throws -> String {
        guard let nightToken = tokenValues.night.first(where: { $0.name == tokenName }) else {
            fallbackWarning(tokenName: tokenName)
            return fallbackValue
        }

        guard case .color(let nightValue) = nightToken.type else {
            fallbackWarning(tokenName: tokenName)
            return fallbackValue
        }

        return try tokensResolver.resolveHexColorValue(nightValue, tokenValues: tokenValues)
    }

    private func resolveNightReference(
        tokenName: String,
        fallbackRefence: String,
        tokenValues: TokenValues
    ) -> String {
        guard let nightToken = tokenValues.night.first(where: { $0.name == tokenName }) else {
            fallbackWarning(tokenName: tokenName)
            return fallbackRefence
        }

        guard case .color(let nightValue) = nightToken.type else {
            fallbackWarning(tokenName: tokenName)
            return fallbackRefence
        }

        return nightValue
    }

    private func makeColorToken(
        dayValue: String,
        tokenName: String,
        tokenValues: TokenValues,
        path: [String]
    ) throws -> ColorToken {
        let dayHexColorValue = try tokensResolver.resolveHexColorValue(
            dayValue,
            tokenValues: tokenValues
        )

        return ColorToken(
            dayTheme: ColorToken.Theme(
                value: dayHexColorValue,
                reference: dayValue
            ),
            nightTheme: ColorToken.Theme(
                value: try resolveNightValue(
                    tokenName: tokenName,
                    fallbackValue: dayHexColorValue,
                    tokenValues: tokenValues
                ),
                reference: resolveNightReference(
                    tokenName: tokenName,
                    fallbackRefence: dayValue,
                    tokenValues: tokenValues
                )
            ),
            name: tokenName,
            path: path
        )
    }

    private func structure(tokenColors: [ColorToken], atNamePath namePath: [String] = []) -> [String: Any] {
        var structuredColors: [String: Any] = [:]

        if let name = namePath.last {
            structuredColors["name"] = name
        }

        if !namePath.isEmpty {
            structuredColors["path"] = namePath
        }

        let colors = tokenColors
            .filter { $0.path.count == namePath.count + 1 }
            .sorted { $0.name.lowercased() < $1.name.lowercased() }

        if !colors.isEmpty {
            structuredColors["colors"] = colors
        }

        let childTokenColors = tokenColors.filter { $0.path.count > namePath.count + 1 }

        let children = Dictionary(grouping: childTokenColors) { $0.path[namePath.count] }
            .sorted { $0.key < $1.key }
            .map { name, colors in
                structure(tokenColors: colors, atNamePath: namePath + [name])
            }

        if !children.isEmpty {
            structuredColors["children"] = children
        }

        return structuredColors
    }

    // MARK: -

    func fetchColorTokensContext(from tokenValues: TokenValues) throws -> [String: Any] {
        let colors: [ColorToken] = try tokenValues.day.compactMap { (token: TokenValue) in
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

        return structure(tokenColors: colors)
    }
}
