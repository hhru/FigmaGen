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

    // MARK: - Initializers

    init(
        tokensProvider: TokensProvider,
        tokensGenerationParametersResolver: TokensGenerationParametersResolver,
        colorTokensGenerator: ColorTokensGenerator,
        baseColorTokensGenerator: BaseColorTokensGenerator,
        fontFamilyTokensGenerator: FontFamilyTokensGenerator,
        typographyTokensGenerator: TypographyTokensGenerator,
        boxShadowTokensGenerator: BoxShadowTokensGenerator,
        themeTokensGenerator: ThemeTokensGenerator
    ) {
        self.tokensProvider = tokensProvider
        self.tokensGenerationParametersResolver = tokensGenerationParametersResolver
        self.colorTokensGenerator = colorTokensGenerator
        self.baseColorTokensGenerator = baseColorTokensGenerator
        self.fontFamilyTokensGenerator = fontFamilyTokensGenerator
        self.typographyTokensGenerator = typographyTokensGenerator
        self.boxShadowTokensGenerator = boxShadowTokensGenerator
        self.themeTokensGenerator = themeTokensGenerator
    }

    // MARK: - Instance Methods

    private func generate(parameters: TokensGenerationParameters) async throws {
        let tokenValues = try await tokensProvider.fetchTokens(from: parameters.file)

        try colorTokensGenerator.generate(
            renderParameters: parameters.tokens.colorRender,
            tokenValues: tokenValues
        )

        try baseColorTokensGenerator.generate(
            renderParameters: parameters.tokens.baseColorRender,
            tokenValues: tokenValues
        )

        try fontFamilyTokensGenerator.generate(
            renderParameters: parameters.tokens.fontFamilyRender,
            tokenValues: tokenValues
        )

        try typographyTokensGenerator.generate(
            renderParameters: parameters.tokens.typographyRender,
            tokenValues: tokenValues
        )

        try boxShadowTokensGenerator.generate(
            renderParameters: parameters.tokens.boxShadowRender,
            tokenValues: tokenValues
        )

        try themeTokensGenerator.generate(
            renderParameters: parameters.tokens.themeRender,
            tokenValues: tokenValues
        )
    }

    // MARK: -

    func generate(configuration: TokensConfiguration) async throws {
        let parameters = try await Task.detached(priority: .userInitiated) {
            try self.tokensGenerationParametersResolver.resolveGenerationParameters(from: configuration)
        }.value

        try await generate(parameters: parameters)
    }
}
