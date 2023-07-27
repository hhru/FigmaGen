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

    private func makeLineHeightToken(
        from value: TokenTypographyValue,
        tokenValues: TokenValues
    ) throws -> TypographyToken.LineHeightToken {
        let lineHeightValue = value.lineHeight
        let lineHeightResolvedValue = try tokensResolver.resolveValue(lineHeightValue, tokenValues: tokenValues)

        guard lineHeightResolvedValue.hasSuffix("%") else {
            return TypographyToken.LineHeightToken(
                path: lineHeightValue.components(separatedBy: "."),
                value: lineHeightResolvedValue
            )
        }

        let fontSize = Double(try tokensResolver.resolveValue(value.fontSize, tokenValues: tokenValues))
        let lineHeight = Double(lineHeightResolvedValue.dropLast()).map { $0 / 100.0 }

        guard let fontSize else {
            throw TypographyTokensGeneratorError(code: .failedExtractFontSize(value: value.fontSize))
        }

        guard let lineHeight else {
            throw TypographyTokensGeneratorError(code: .failedExtractLetterSpacing(value: lineHeightValue))
        }

        let fontLineHeight = fontSize * lineHeight

        return TypographyToken.LineHeightToken(
            path: lineHeightValue.components(separatedBy: "."),
            value: String(round(fontLineHeight * 100) / 100.0)
        )
    }

    private func makeLetterSpacingToken(
        from value: TokenTypographyValue,
        tokenValues: TokenValues
    ) throws -> TypographyToken.LetterSpacingToken? {
        guard let letterSpacingValue = value.letterSpacing else {
            return nil
        }

        let letterSpacing = Double(
            try tokensResolver
                .resolveValue(letterSpacingValue, tokenValues: tokenValues)
                .removingFirst("%")
        ).map { $0 / 100.0 }

        let fontSize = Double(
            try tokensResolver.resolveValue(value.fontSize, tokenValues: tokenValues)
        )

        guard let fontSize else {
            throw TypographyTokensGeneratorError(code: .failedExtractFontSize(value: value.fontSize))
        }

        guard let letterSpacing else {
            throw TypographyTokensGeneratorError(code: .failedExtractLetterSpacing(value: letterSpacingValue))
        }

        let fontLetterSpacing = fontSize * letterSpacing

        return TypographyToken.LetterSpacingToken(
            path: letterSpacingValue.components(separatedBy: "."),
            value: String(round(fontLetterSpacing * 100) / 100.0)
        )
    }

    private func makeContextToken(value: String, tokenValues: TokenValues) throws -> ContextToken {
        ContextToken(
            path: value.components(separatedBy: "."),
            value: try tokensResolver.resolveValue(value, tokenValues: tokenValues)
        )
    }

    private func makeTypographyToken(
        tokenValue: TokenValue,
        value: TokenTypographyValue,
        tokenValues: TokenValues
    ) throws -> TypographyToken {
        TypographyToken(
            path: tokenValue.name.components(separatedBy: "."),
            name: tokenValue.name,
            fontFamily: try makeContextToken(value: value.fontFamily, tokenValues: tokenValues),
            fontWeight: try makeContextToken(value: value.fontWeight, tokenValues: tokenValues),
            lineHeight: try makeLineHeightToken(from: value, tokenValues: tokenValues),
            fontSize: try makeContextToken(value: value.fontSize, tokenValues: tokenValues),
            letterSpacing: try makeLetterSpacingToken(from: value, tokenValues: tokenValues),
            paragraphSpacing: try makeContextToken(value: value.paragraphSpacing, tokenValues: tokenValues),
            paragraphIndent: try value.paragraphIndent.map { paragraphIndent in
                try makeContextToken(value: paragraphIndent, tokenValues: tokenValues)
            },
            textDecoration: try value.textDecoration.map { textDecoration in
                try makeContextToken(value: textDecoration, tokenValues: tokenValues)
            },
            fontScale: try value.fontScale.map { fontScale in
                try makeContextToken(value: fontScale, tokenValues: tokenValues)
            }
        )
    }

    private func makeTypographyTokens(tokenValues: TokenValues) throws -> [TypographyToken] {
        try tokenValues.typography.compactMap { tokenValue in
            guard case let .typography(value) = tokenValue.type else {
                return nil
            }

            return try makeTypographyToken(tokenValue: tokenValue, value: value, tokenValues: tokenValues)
        }
    }

    private func structure(tokens: [TypographyToken], atPath path: [String] = []) -> [String: Any] {
        var structuredTypography: [String: Any] = [:]

        if let name = path.last {
            structuredTypography["name"] = name
        }

        let typographies = tokens
            .filter { $0.path.removingFirst("typography").count == path.count + 1 }
            .sorted { $0.name.lowercased() < $1.name.lowercased() }

        if !typographies.isEmpty {
            structuredTypography["typographies"] = typographies
        }

        let childTypographyTokens = tokens.filter { $0.path.removingFirst("typography").count > path.count + 1 }

        let children = Dictionary(grouping: childTypographyTokens) { $0.path.removingFirst("typography")[path.count] }
            .sorted { $0.key < $1.key }
            .map { name, tokens in
                structure(tokens: tokens, atPath: path + [name])
            }

        if !children.isEmpty {
            structuredTypography["children"] = children
        }

        return structuredTypography
    }

    // MARK: -

    func generate(renderParameters: RenderParameters, tokenValues: TokenValues) throws {
        let tokens = try makeTypographyTokens(tokenValues: tokenValues)

        try templateRenderer.renderTemplate(
            renderParameters.template,
            to: renderParameters.destination,
            context: [
                "typographies": tokens,
                "structuredTypography": structure(tokens: tokens)
            ]
        )
    }
}
