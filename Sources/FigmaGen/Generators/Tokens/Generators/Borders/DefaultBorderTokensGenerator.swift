import Foundation

struct DefaultBorderTokensGenerator: BorderTokensGenerator {

    // MARK: - Instance properties

    private let tokensResolver: TokensResolver
    private let templateRenderer: TemplateRenderer

    // MARK: - Initializers

    init(tokensResolver: TokensResolver, templateRenderer: TemplateRenderer) {
        self.tokensResolver = tokensResolver
        self.templateRenderer = templateRenderer
    }

    // MARK: - Private instance methods

    private func getBorderToken(
        from token: TokenValue,
        tokens: TokenValues
    ) throws -> BorderToken? {
        guard case .border(let value) = token.type else {
            return nil
        }

        return BorderToken(
            path: token.name.components(separatedBy: "."),
            width: try tokensResolver.resolveValue(
                value.width,
                tokenValues: tokens,
                theme: nil
            ),
            style: value.style
        )
    }

    private func getBorderWidth(
        from token: TokenValue,
        tokens: TokenValues
    ) throws -> BorderWidthToken? {
        guard case .borderWidth(let value) = token.type else {
            return nil
        }

        return BorderWidthToken(
            path: token.name.components(separatedBy: "."),
            value: try tokensResolver.resolveValue(
                value,
                tokenValues: tokens,
                theme: nil
            )
        )
    }

    private func extractBorderData(
        from tokens: [TokenValue],
        tokenValues: TokenValues
    ) throws -> (borders: [BorderToken], borderWidth: [BorderWidthToken]) {
        try tokens.reduce((borders: [BorderToken](), borderWidth: [BorderWidthToken]())) { partialResult, value in
            var result = partialResult

            if let borderToken = try getBorderToken(from: value, tokens: tokenValues) {
                result.borders.append(borderToken)
            }

            if let borderWidth = try getBorderWidth(from: value, tokens: tokenValues) {
                result.borderWidth.append(borderWidth)
            }

            return result
        }
    }

    // MARK: - BorderTokensGenerator

    func generate(
        renderParameters: RenderParameters,
        tokenValues: TokenValues,
        themes: [Theme],
        fallbackTheme: Theme
    ) throws {
        let coreBorderData = try extractBorderData(from: tokenValues.core, tokenValues: tokenValues)
        let semanticBorderData = try extractBorderData(from: tokenValues.semantic, tokenValues: tokenValues)

        try templateRenderer.renderTemplate(
            renderParameters.template,
            to: renderParameters.destination,
            context: [
                "coreBorders": coreBorderData.borders,
                "semanticBorders": semanticBorderData.borders,
                "coreBorderWidth": coreBorderData.borderWidth,
                "semanticBorderWidth": semanticBorderData.borderWidth
            ]
        )
    }
}
