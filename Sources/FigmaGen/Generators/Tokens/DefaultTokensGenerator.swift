import Foundation
import FigmaGenTools
import Expression

final class DefaultTokensGenerator: TokensGenerator {

    // MARK: - Instance Properties

    let tokensProvider: TokensProvider
    let tokensGenerationParametersResolver: TokensGenerationParametersResolver
    let colorTokensGenerator: ColorTokensGenerator
    let baseColorTokensGenerator: BaseColorTokensGenerator
    let fontFamilyTokensGenerator: FontFamilyTokensGenerator
    let typographyTokensGenerator: TypographyTokensGenerator
    let boxShadowTokensGenerator: BoxShadowTokensGenerator
    let themeTokensGenerator: ThemeTokensGenerator
    let spacingTokensGenerator: SpacingTokensGenerator

    // MARK: - Initializers

    init(
        tokensProvider: TokensProvider,
        tokensGenerationParametersResolver: TokensGenerationParametersResolver,
        colorTokensGenerator: ColorTokensGenerator,
        baseColorTokensGenerator: BaseColorTokensGenerator,
        fontFamilyTokensGenerator: FontFamilyTokensGenerator,
        typographyTokensGenerator: TypographyTokensGenerator,
        boxShadowTokensGenerator: BoxShadowTokensGenerator,
        themeTokensGenerator: ThemeTokensGenerator,
        spacingTokensGenerator: SpacingTokensGenerator
    ) {
        self.tokensProvider = tokensProvider
        self.tokensGenerationParametersResolver = tokensGenerationParametersResolver
        self.colorTokensGenerator = colorTokensGenerator
        self.baseColorTokensGenerator = baseColorTokensGenerator
        self.fontFamilyTokensGenerator = fontFamilyTokensGenerator
        self.typographyTokensGenerator = typographyTokensGenerator
        self.boxShadowTokensGenerator = boxShadowTokensGenerator
        self.themeTokensGenerator = themeTokensGenerator
        self.spacingTokensGenerator = spacingTokensGenerator
    }

    // MARK: - Instance Methods

    private func generate(parameters: TokensGenerationParameters) async throws {
        let tokenValues = try await tokensProvider.fetchTokens(from: parameters.file)

        if let colorRenderParameters = parameters.tokens.colorRender {
            try colorTokensGenerator.generate(
                renderParameters: colorRenderParameters,
                tokenValues: tokenValues
            )
        }

        if let baseColorRenderParameters = parameters.tokens.baseColorRender {
            try baseColorTokensGenerator.generate(
                renderParameters: baseColorRenderParameters,
                tokenValues: tokenValues
            )
        }

        if let fontFamilyRenderParameters = parameters.tokens.fontFamilyRender {
            try fontFamilyTokensGenerator.generate(
                renderParameters: fontFamilyRenderParameters,
                tokenValues: tokenValues
            )
        }

        if let typographyRenderParameters = parameters.tokens.typographyRender {
            try typographyTokensGenerator.generate(
                renderParameters: typographyRenderParameters,
                tokenValues: tokenValues
            )
        }

        if let boxShadowRenderParameters = parameters.tokens.boxShadowRender {
            try boxShadowTokensGenerator.generate(
                renderParameters: boxShadowRenderParameters,
                tokenValues: tokenValues
            )
        }

        if let themeRenderParameters = parameters.tokens.themeRender {
            try themeTokensGenerator.generate(
                renderParameters: themeRenderParameters,
                tokenValues: tokenValues
            )
        }

        if let spacingRenderParameters = parameters.tokens.spacingRender {
            try spacingTokensGenerator.generate(
                renderParameters: spacingRenderParameters,
                tokenValues: tokenValues
            )
        }
    }

    // MARK: -

    func generate(configuration: TokensConfiguration) async throws {
        let parameters = try await Task.detached(priority: .userInitiated) {
            try self.tokensGenerationParametersResolver.resolveGenerationParameters(from: configuration)
        }.value

        try await generate(parameters: parameters)
    }
}
