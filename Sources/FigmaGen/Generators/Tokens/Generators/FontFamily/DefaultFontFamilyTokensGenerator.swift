import Foundation

final class DefaultFontFamilyTokensGenerator: FontFamilyTokensGenerator {

    // MARK: - Instance Properties

    let tokensResolver: TokensResolver
    let templateRenderer: TemplateRenderer

    // MARK: - Initializers

    init(tokensResolver: TokensResolver, templateRenderer: TemplateRenderer) {
        self.tokensResolver = tokensResolver
        self.templateRenderer = templateRenderer
    }

    // MARK: - Instance Methods

    private func makeFontFamilyTokens(tokenValues: TokenValues) throws -> [FontFamilyToken] {
        try tokenValues.typography.compactMap { tokenValue in
            guard case let .fontFamilies(value) = tokenValue.type else {
                return nil
            }

            return FontFamilyToken(
                path: tokenValue.name.components(separatedBy: "."),
                value: try tokensResolver.resolveValue(value, tokenValues: tokenValues)
            )
        }
    }

    private func makeFontWightTokens(tokenValues: TokenValues) throws -> [FontWeightToken] {
        try tokenValues.typography.compactMap { tokenValue in
            guard case let .fontWeights(value) = tokenValue.type else {
                return nil
            }

            return FontWeightToken(
                path: tokenValue.name.components(separatedBy: "."),
                value: try tokensResolver.resolveValue(value, tokenValues: tokenValues)
            )
        }
    }

    // MARK: -

    func generate(renderParameters: RenderParameters, tokenValues: TokenValues) throws {
        let fontFamilyTokens = try makeFontFamilyTokens(tokenValues: tokenValues)
        let fontWeightTokens = try makeFontWightTokens(tokenValues: tokenValues)

        try templateRenderer.renderTemplate(
            renderParameters.template,
            to: renderParameters.destination,
            context: [
                "fontFamilies": fontFamilyTokens,
                "fontWeights": fontWeightTokens
            ]
        )
    }
}
