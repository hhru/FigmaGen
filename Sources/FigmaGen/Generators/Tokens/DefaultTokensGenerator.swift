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

        try generateColorsTokens(parameters: parameters, tokenValues: tokenValues)
        try generateBaseColorsTokens(parameters: parameters, tokenValues: tokenValues)
        try generateFontFamilyTokens(parameters: parameters, tokenValues: tokenValues)
        try generateTypographyTokens(parameters: parameters, tokenValues: tokenValues)
        try generateBoxShadowTokens(parameters: parameters, tokenValues: tokenValues)
        try generateThemeTokens(parameters: parameters, tokenValues: tokenValues)
        try generateSpacingTokens(parameters: parameters, tokenValues: tokenValues)
    }

    private func generateSpacingTokens(parameters: TokensGenerationParameters, tokenValues: TokenValues) throws {
        if let spacingRenderParameters = parameters.tokens.spacingRenderParameters {
            for renderParameters in spacingRenderParameters {
                try spacingTokensGenerator.generate(
                    renderParameters: renderParameters,
                    tokenValues: tokenValues
                )
            }
        }
    }

    private func generateThemeTokens(parameters: TokensGenerationParameters, tokenValues: TokenValues) throws {
        if let themeRenderParameters = parameters.tokens.themeRenderParameters {
            for renderParameters in themeRenderParameters {
                try themeTokensGenerator.generate(
                    renderParameters: renderParameters,
                    tokenValues: tokenValues
                )
            }
        }
    }

    private func generateBoxShadowTokens(parameters: TokensGenerationParameters, tokenValues: TokenValues) throws {
        if let boxShadowRenderParameters = parameters.tokens.boxShadowRenderParameters {
            for renderParameters in boxShadowRenderParameters {
                try boxShadowTokensGenerator.generate(
                    renderParameters: renderParameters,
                    tokenValues: tokenValues
                )
            }
        }
    }

    private func generateTypographyTokens(parameters: TokensGenerationParameters, tokenValues: TokenValues) throws {
        if let typographyRenderParameters = parameters.tokens.typographyRenderParameters {
            for renderParameters in typographyRenderParameters {
                try typographyTokensGenerator.generate(
                    renderParameters: renderParameters,
                    tokenValues: tokenValues
                )
            }
        }
    }

    private func generateFontFamilyTokens(parameters: TokensGenerationParameters, tokenValues: TokenValues) throws {
        if let fontFamilyRenderParameters = parameters.tokens.fontFamilyRenderParameters {
            for renderParameters in fontFamilyRenderParameters {
                try fontFamilyTokensGenerator.generate(
                    renderParameters: renderParameters,
                    tokenValues: tokenValues
                )
            }
        }
    }

    private func generateBaseColorsTokens(parameters: TokensGenerationParameters, tokenValues: TokenValues) throws {
        if let baseColorRenderParameters = parameters.tokens.baseColorRenderParameters {
            for renderParameters in baseColorRenderParameters {
                try baseColorTokensGenerator.generate(
                    renderParameters: renderParameters,
                    tokenValues: tokenValues
                )
            }
        }
    }

    private func generateColorsTokens(parameters: TokensGenerationParameters, tokenValues: TokenValues) throws {
        if let colorRenderParameters = parameters.tokens.colorRenderParameters {
            for renderParameters in colorRenderParameters {
                try colorTokensGenerator.generate(
                    renderParameters: renderParameters,
                    tokenValues: tokenValues
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
