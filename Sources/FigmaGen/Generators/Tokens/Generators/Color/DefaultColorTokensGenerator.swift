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

    // MARK: -

    func generate(renderParameters: RenderParameters, tokenValues: TokenValues) throws {
        let colors: [ColorToken] = try tokenValues.day.compactMap { (token: TokenValue) in
            guard case .color(let dayValue) = token.type else {
                return nil
            }

            let path = token.name.components(separatedBy: ".")

            guard path[0] == "color" && path[1] != "component" else {
                return nil
            }

            return ColorToken(
                dayValue: try tokensResolver.resolveHexColorValue(
                    dayValue,
                    tokenValues: tokenValues
                ),
                nightValue: try resolveNightValue(
                    tokenName: token.name,
                    fallbackValue: dayValue,
                    tokenValues: tokenValues
                ),
                name: token.name,
                path: path.removingFirst()
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
