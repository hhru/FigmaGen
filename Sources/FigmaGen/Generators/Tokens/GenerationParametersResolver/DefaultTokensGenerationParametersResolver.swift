import Foundation

final class DefaultTokensGenerationParametersResolver: TokensGenerationParametersResolver {

    // MARK: - Instance Properties

    let renderParametersResolver: RenderParametersResolver

    // MARK: - Initializers

    init(renderParametersResolver: RenderParametersResolver) {
        self.renderParametersResolver = renderParametersResolver
    }

    // MARK: - Instance Methods

    private func resolveAccessToken(configuration: TokensConfiguration) -> String? {
        switch configuration.accessToken {
        case let .value(accessToken):
            return accessToken

        case let .environmentVariable(environmentVariable):
            return ProcessInfo.processInfo.environment[environmentVariable]

        case nil:
            return nil
        }
    }

    // MARK: -

    // swiftlint:disable:next function_body_length
    func resolveGenerationParameters(from configuration: TokensConfiguration) throws -> TokensGenerationParameters {
        guard let fileConfiguration = configuration.file else {
            throw GenerationParametersError.invalidFileConfiguration
        }

        guard let accessToken = resolveAccessToken(configuration: configuration) else {
            throw GenerationParametersError.invalidAccessToken
        }

        let file = FileParameters(
            key: fileConfiguration.key,
            version: fileConfiguration.version,
            accessToken: accessToken
        )

        let colorRenderParameters = renderParametersResolver.resolveRenderParameters(
            templates: configuration.templates?.colors,
            nativeTemplateName: "ColorTokens"
        )

        let baseColorRenderParameters = renderParametersResolver.resolveRenderParameters(
            templates: configuration.templates?.baseColors,
            nativeTemplateName: "BaseColorTokens"
        )

        let fontFamilyRenderParameters = renderParametersResolver.resolveRenderParameters(
            templates: configuration.templates?.fontFamilies,
            nativeTemplateName: "FontFamilyTokens"
        )

        let typographyRenderParameters = renderParametersResolver.resolveRenderParameters(
            templates: configuration.templates?.typographies,
            nativeTemplateName: "TypographyTokens"
        )

        let boxShadowRenderParameters = renderParametersResolver.resolveRenderParameters(
            templates: configuration.templates?.boxShadows,
            nativeTemplateName: "BoxShadowTokens"
        )

        let themeRenderParameters = renderParametersResolver.resolveRenderParameters(
            templates: configuration.templates?.theme,
            nativeTemplateName: "Theme"
        )

        let spacingRenderParameters = renderParametersResolver.resolveRenderParameters(
            templates: configuration.templates?.spacing,
            nativeTemplateName: "SpacingTokens"
        )

        return TokensGenerationParameters(
            file: file,
            tokens: TokensGenerationParameters.TokensParameters(
                colorRenderParameters: colorRenderParameters,
                baseColorRenderParameters: baseColorRenderParameters,
                fontFamilyRenderParameters: fontFamilyRenderParameters,
                typographyRenderParameters: typographyRenderParameters,
                boxShadowRenderParameters: boxShadowRenderParameters,
                themeRenderParameters: themeRenderParameters,
                spacingRenderParameters: spacingRenderParameters
            )
        )
    }
}
