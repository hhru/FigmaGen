import Foundation

final class DefaultColorTokensGenerator: ColorTokensGenerator {

    // MARK: - Instance Properties

    let tokensResolver: TokensResolver
    let templateRenderer: TemplateRenderer

    // MARK: - Initializers

    init(tokensResolver: TokensResolver, templateRenderer: TemplateRenderer) {
        self.tokensResolver = tokensResolver
        self.templateRenderer = templateRenderer
    }

    // MARK: - Instance Methods

    private func resolveNightValue(
        tokenName: String,
        fallbackValue: String,
        tokenValues: TokenValues
    ) throws -> String {
        guard let nightToken = tokenValues.night.first(where: { $0.name == tokenName }) else {
            return fallbackValue
        }

        guard case .color(let nightValue) = nightToken.type else {
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
            return fallbackRefence
        }

        guard case .color(let nightValue) = nightToken.type else {
            return fallbackRefence
        }

        return nightValue
    }

    private func structure(tokenColors: [ColorToken], atNamePath namePath: [String] = []) -> [String: Any] {
        var structuredColors: [String: Any] = [:]

        if let name = namePath.last {
            structuredColors["name"] = name
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

    // MARK: -

    func generate(renderParameters: RenderParameters, tokenValues: TokenValues) throws {
        let colors: [ColorToken] = try tokenValues.day.compactMap { (token: TokenValue) in
            guard case .color(let dayValue) = token.type else {
                return nil
            }

            let path = token.name.components(separatedBy: ".")

            guard path[0] != "gradient" else {
                return nil
            }

            return try makeColorToken(
                dayValue: dayValue,
                tokenName: token.name,
                tokenValues: tokenValues,
                path: path
            )
        }

        let structuredColors = structure(tokenColors: colors)

        try templateRenderer.renderTemplate(
            renderParameters.template,
            to: renderParameters.destination,
            context: ["colorTokens": structuredColors]
        )
    }
}
