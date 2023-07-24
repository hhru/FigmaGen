import Foundation

final class DefaultTypographyTokensGenerator: TypographyTokensGenerator {

    // MARK: - Instance Properties

    let tokensResolver: TokensResolver
    let templateRenderer: TemplateRenderer

    // MARK: - Initializers

    init(tokensResolver: TokensResolver, templateRenderer: TemplateRenderer) {
        self.tokensResolver = tokensResolver
        self.templateRenderer = templateRenderer
    }

    // MARK: - Instance Methods

    private func makeLetterSpacing(
        from value: TokenTypographyValue,
        tokenValues: TokenValues
    ) throws -> TypographyToken.LetterSpacingToken {
        let letterSpacing = Double(
            try tokensResolver
                .resolveValue(value.letterSpacing, tokenValues: tokenValues)
                .removingFirst("%")
        ).map { $0 / 100.0 }

        let fontSize = Double(
            try tokensResolver.resolveValue(value.fontSize, tokenValues: tokenValues)
        )

        guard let fontSize else {
            throw TypographyTokensGeneratorError(code: .failedExtractFontSize(value: value.fontSize))
        }

        guard let letterSpacing else {
            throw TypographyTokensGeneratorError(code: .failedExtractLetterSpacing(value: value.letterSpacing))
        }

        let fontLetterSpacing = fontSize * letterSpacing

        return TypographyToken.LetterSpacingToken(
            path: value.letterSpacing.components(separatedBy: "."),
            value: String(round(fontLetterSpacing * 100) / 100.0)
        )
    }

    private func makeTypographyTokens(tokenValues: TokenValues) throws -> [TypographyToken] {
        try tokenValues.typography.compactMap { tokenValue in
            guard case let .typography(value) = tokenValue.type else {
                return nil
            }

            return TypographyToken(
                path: tokenValue.name.components(separatedBy: "."),
                fontFamily: FontFamilyToken(
                    path: value.fontFamily.components(separatedBy: "."),
                    value: try tokensResolver.resolveValue(value.fontFamily, tokenValues: tokenValues)
                ),
                fontWeight: FontWeightToken(
                    path: value.fontWeight.components(separatedBy: "."),
                    value: try tokensResolver.resolveValue(value.fontWeight, tokenValues: tokenValues)
                ),
                fontSize: TypographyToken.FontSizeToken(
                    path: value.fontSize.components(separatedBy: "."),
                    value: try tokensResolver.resolveValue(value.fontSize, tokenValues: tokenValues)
                ),
                fontScale: TypographyToken.FontScaleToken(
                    path: value.fontScale.components(separatedBy: "."),
                    value: try tokensResolver.resolveValue(value.fontScale, tokenValues: tokenValues)
                ),
                letterSpacing: try makeLetterSpacing(from: value, tokenValues: tokenValues),
                lineHeight: TypographyToken.LineHeightToken(
                    path: value.lineHeight.components(separatedBy: "."),
                    value: try tokensResolver.resolveValue(value.lineHeight, tokenValues: tokenValues)
                )
            )
        }
    }

    // MARK: -

    func generate(renderParameters: RenderParameters, tokenValues: TokenValues) throws {
        let tokens = try makeTypographyTokens(tokenValues: tokenValues)

        try templateRenderer.renderTemplate(
            renderParameters.template,
            to: renderParameters.destination,
            context: ["typographies": tokens]
        )
    }
}
