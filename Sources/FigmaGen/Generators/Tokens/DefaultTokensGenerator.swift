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
    let bordersTokensGenerator: BorderTokensGenerator
    let borderRadiusesTokensGenerator: BorderRadiusTokensGenerator
    let gradientTokensGenerator: GradientTokensGenerator
    let animationTimeTokensGenerator: AnimationTimeTokensGenerator
    let animationEaseTokensGenerator: AnimationEaseTokensGenerator
    let blurTokensGenerator: BlurTokensGenerator

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
        spacingTokensGenerator: SpacingTokensGenerator,
        bordersTokensGenerator: BorderTokensGenerator,
        borderRadiusesTokensGenerator: BorderRadiusTokensGenerator,
        gradientTokensGenerator: GradientTokensGenerator,
        animationTimeTokensGenerator: AnimationTimeTokensGenerator,
        animationEaseTokensGenerator: AnimationEaseTokensGenerator,
        blurTokensGenerator: BlurTokensGenerator
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
        self.bordersTokensGenerator = bordersTokensGenerator
        self.borderRadiusesTokensGenerator = borderRadiusesTokensGenerator
        self.gradientTokensGenerator = gradientTokensGenerator
        self.animationTimeTokensGenerator = animationTimeTokensGenerator
        self.animationEaseTokensGenerator = animationEaseTokensGenerator
        self.blurTokensGenerator = blurTokensGenerator
    }

    // MARK: - Instance Methods

    private func generate(parameters: TokensGenerationParameters) async throws {
        let tokenValues = try await fetchTokens(from: parameters)

        try generateColorsTokens(parameters: parameters, tokenValues: tokenValues)
        try generateBaseColorsTokens(parameters: parameters, tokenValues: tokenValues)
        try generateFontFamilyTokens(parameters: parameters, tokenValues: tokenValues)
        try generateTypographyTokens(parameters: parameters, tokenValues: tokenValues)
        try generateBoxShadowTokens(parameters: parameters, tokenValues: tokenValues)
        try generateThemeTokens(parameters: parameters, tokenValues: tokenValues)
        try generateSpacingTokens(parameters: parameters, tokenValues: tokenValues)
        try generateBorderTokens(parameters: parameters, tokenValues: tokenValues)
        try generateBorderRadiusTokens(parameters: parameters, tokenValues: tokenValues)
        try generateGradientTokens(parameters: parameters, tokenValues: tokenValues)
        try generateAnimationTimeTokens(parameters: parameters, tokenValues: tokenValues)
        try generateAnimationEaseTokens(parameters: parameters, tokenValues: tokenValues)
        try generateBlurTokens(parameters: parameters, tokenValues: tokenValues)
    }

    private func fetchTokens(from parameters: TokensGenerationParameters) async throws -> TokenValues {
        if let file = parameters.file {
            return try await tokensProvider.fetchTokens(from: file)
        } else if let remoteFile = parameters.remoteFile {
            return try await tokensProvider.fetchTokens(from: remoteFile)
        } else {
            throw GenerationParametersError.invalidFileConfiguration
        }
    }

    private func generateSpacingTokens(parameters: TokensGenerationParameters, tokenValues: TokenValues) throws {
        try generateTokens(
            spacingTokensGenerator,
            tokensName: "spacings",
            renderParameters: parameters.tokens.spacingRenderParameters,
            tokenValues: tokenValues,
            themes: parameters.themes,
            fallbackTheme: parameters.fallbackTheme
        )
    }

    private func generateThemeTokens(parameters: TokensGenerationParameters, tokenValues: TokenValues) throws {
        try generateTokens(
            themeTokensGenerator,
            tokensName: "theme",
            renderParameters: parameters.tokens.themeRenderParameters,
            tokenValues: tokenValues,
            themes: parameters.themes,
            fallbackTheme: parameters.fallbackTheme
        )
    }

    private func generateBoxShadowTokens(parameters: TokensGenerationParameters, tokenValues: TokenValues) throws {
        try generateTokens(
            boxShadowTokensGenerator,
            tokensName: "box shadow",
            renderParameters: parameters.tokens.boxShadowRenderParameters,
            tokenValues: tokenValues,
            themes: parameters.themes,
            fallbackTheme: parameters.fallbackTheme
        )
    }

    private func generateTypographyTokens(parameters: TokensGenerationParameters, tokenValues: TokenValues) throws {
        try generateTokens(
            typographyTokensGenerator,
            tokensName: "typography",
            renderParameters: parameters.tokens.typographyRenderParameters,
            tokenValues: tokenValues,
            themes: parameters.themes,
            fallbackTheme: parameters.fallbackTheme
        )
    }

    private func generateFontFamilyTokens(parameters: TokensGenerationParameters, tokenValues: TokenValues) throws {
        try generateTokens(
            fontFamilyTokensGenerator,
            tokensName: "font family",
            renderParameters: parameters.tokens.fontFamilyRenderParameters,
            tokenValues: tokenValues,
            themes: parameters.themes,
            fallbackTheme: parameters.fallbackTheme
        )
    }

    private func generateBaseColorsTokens(parameters: TokensGenerationParameters, tokenValues: TokenValues) throws {
        try generateTokens(
            baseColorTokensGenerator,
            tokensName: "base colors",
            renderParameters: parameters.tokens.baseColorRenderParameters,
            tokenValues: tokenValues,
            themes: parameters.themes,
            fallbackTheme: parameters.fallbackTheme
        )
    }

    private func generateColorsTokens(parameters: TokensGenerationParameters, tokenValues: TokenValues) throws {
        try generateTokens(
            colorTokensGenerator,
            tokensName: "colors",
            renderParameters: parameters.tokens.colorRenderParameters,
            tokenValues: tokenValues,
            themes: parameters.themes,
            fallbackTheme: parameters.fallbackTheme
        )
    }

    private func generateBorderTokens(parameters: TokensGenerationParameters, tokenValues: TokenValues) throws {
        try generateTokens(
            bordersTokensGenerator,
            tokensName: "border",
            renderParameters: parameters.tokens.bordersRenderParameters,
            tokenValues: tokenValues,
            themes: parameters.themes,
            fallbackTheme: parameters.fallbackTheme
        )
    }

    private func generateBorderRadiusTokens(parameters: TokensGenerationParameters, tokenValues: TokenValues) throws {
        try generateTokens(
            borderRadiusesTokensGenerator,
            tokensName: "borderRadius",
            renderParameters: parameters.tokens.borderRadiusesRenderParameters,
            tokenValues: tokenValues,
            themes: parameters.themes,
            fallbackTheme: parameters.fallbackTheme
        )
    }

    private func generateGradientTokens(parameters: TokensGenerationParameters, tokenValues: TokenValues) throws {
        try generateTokens(
            gradientTokensGenerator,
            tokensName: "gradients",
            renderParameters: parameters.tokens.gradientsRenderParameters,
            tokenValues: tokenValues,
            themes: parameters.themes,
            fallbackTheme: parameters.fallbackTheme
        )
    }

    private func generateAnimationTimeTokens(parameters: TokensGenerationParameters, tokenValues: TokenValues) throws {
        try generateTokens(
            animationTimeTokensGenerator,
            tokensName: "animationTime",
            renderParameters: parameters.tokens.animationTimesRenderParameters,
            tokenValues: tokenValues,
            themes: parameters.themes,
            fallbackTheme: parameters.fallbackTheme
        )
    }

    private func generateAnimationEaseTokens(parameters: TokensGenerationParameters, tokenValues: TokenValues) throws {
        try generateTokens(
            animationEaseTokensGenerator,
            tokensName: "animationEase",
            renderParameters: parameters.tokens.animationEasesRenderParameters,
            tokenValues: tokenValues,
            themes: parameters.themes,
            fallbackTheme: parameters.fallbackTheme
        )
    }

    private func generateBlurTokens(parameters: TokensGenerationParameters, tokenValues: TokenValues) throws {
        try generateTokens(
            blurTokensGenerator,
            tokensName: "blur",
            renderParameters: parameters.tokens.blurRenderParameters,
            tokenValues: tokenValues,
            themes: parameters.themes,
            fallbackTheme: parameters.fallbackTheme
        )
    }

    private func generateTokens(
        _ generator: BaseTokenGenerator,
        tokensName: String,
        renderParameters: [RenderParameters]?,
        tokenValues: TokenValues,
        themes: [Theme],
        fallbackTheme: Theme
    ) throws {
        if let renderParametersList = renderParameters {
            for params in renderParametersList {
                logger.info("📦 Generating \(tokensName) tokens...", highlighted: true)
                try generator.generate(
                    renderParameters: params,
                    tokenValues: tokenValues,
                    themes: themes,
                    fallbackTheme: fallbackTheme
                )
            }
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
