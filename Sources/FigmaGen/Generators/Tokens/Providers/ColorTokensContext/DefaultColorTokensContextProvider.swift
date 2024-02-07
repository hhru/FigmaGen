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
        guard let nightToken = tokenValues.hhNight.first(where: { $0.name == tokenName }) else {
            fallbackWarning(tokenName: tokenName)
            return fallbackValue
        }

        guard case .color(let nightValue) = nightToken.type else {
            fallbackWarning(tokenName: tokenName)
            return fallbackValue
        }

        return try tokensResolver.resolveHexColorValue(
            nightValue,
            tokenValues: tokenValues,
            theme: .night
        )
    }

    private func resolveNightReference(
        tokenName: String,
        fallbackRefence: String,
        tokenValues: TokenValues
    ) throws -> String {
        guard let nightToken = tokenValues.hhNight.first(where: { $0.name == tokenName }) else {
            fallbackWarning(tokenName: tokenName)
            return fallbackRefence
        }

        guard case .color(let nightValue) = nightToken.type else {
            fallbackWarning(tokenName: tokenName)
            return fallbackRefence
        }

        return try tokensResolver.resolveBaseReference(nightValue, tokenValues: tokenValues.hhNight)
    }
    
    private func resolveZpDayValue(
        tokenName: String,
        fallbackValue: String,
        tokenValues: TokenValues
    ) throws -> String {
        guard let zpDayToken = tokenValues.hhNight.first(where: { $0.name == tokenName }) else {
            fallbackWarning(tokenName: tokenName)
            return fallbackValue
        }

        guard case .color(let zpDayValue) = zpDayToken.type else {
            fallbackWarning(tokenName: tokenName)
            return fallbackValue
        }

        return try tokensResolver.resolveHexColorValue(
            zpDayValue,
            tokenValues: tokenValues,
            theme: .zpDay
        )
    }

    private func resolveZpDayReference(
        tokenName: String,
        fallbackRefence: String,
        tokenValues: TokenValues
    ) throws -> String {
        guard let zpDayToken = tokenValues.zpDay.first(where: { $0.name == tokenName }) else {
            fallbackWarning(tokenName: tokenName)
            return fallbackRefence
        }

        guard case .color(let zpDayValue) = zpDayToken.type else {
            fallbackWarning(tokenName: tokenName)
            return fallbackRefence
        }

        return try tokensResolver.resolveBaseReference(zpDayValue, tokenValues: tokenValues.zpDay)
    }

    private func makeColorToken(
        dayValue: String,
        tokenName: String,
        tokenValues: TokenValues,
        path: [String]
    ) throws -> ColorToken {
        let dayHexColorValue = try tokensResolver.resolveHexColorValue(
            dayValue,
            tokenValues: tokenValues,
            theme: .day
        )

        let dayReference = try tokensResolver.resolveBaseReference(
            dayValue,
            tokenValues: tokenValues.hhDay
        )

        let nightReference = try resolveNightReference(
            tokenName: tokenName,
            fallbackRefence: dayValue,
            tokenValues: tokenValues
        )

        let nightHexColorValue = try resolveNightValue(
            tokenName: tokenName,
            fallbackValue: dayHexColorValue,
            tokenValues: tokenValues
        )

        let nightReference = try resolveNightReference(
            tokenName: tokenName,
            fallbackRefence: dayValue,
            tokenValues: tokenValues
        )

        let zpDayHexColorValue = try resolveZpDayValue(
            tokenName: tokenName,
            fallbackValue: dayHexColorValue,
            tokenValues: tokenValues
        )

        let zpDayReference = try resolveZpDayReference(
            tokenName: tokenName,
            fallbackRefence: dayValue,
            tokenValues: tokenValues
        )

        return ColorToken(
            dayTheme: ColorToken.Theme(value: dayHexColorValue, reference: dayReference),
            nightTheme: ColorToken.Theme(value: nightHexColorValue, reference:  nightReference),
            zpDayTheme: ColorToken.Theme(value: zpDayHexColorValue, reference:  zpDayReference),
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

        return structure(tokenColors: colors)
    }
}
