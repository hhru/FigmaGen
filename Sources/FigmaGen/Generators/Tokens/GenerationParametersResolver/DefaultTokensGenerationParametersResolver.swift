import Foundation

final class DefaultTokensGenerationParametersResolver: TokensGenerationParametersResolver {

    // MARK: - Instance Properties

    let renderParametersResolver: RenderParametersResolver
    let accessTokenResolver: AccessTokenResolver

    // MARK: - Initializers

    init(
        renderParametersResolver: RenderParametersResolver,
        accessTokenResolver: AccessTokenResolver
    ) {
        self.renderParametersResolver = renderParametersResolver
        self.accessTokenResolver = accessTokenResolver
    }

    // MARK: -

    // swiftlint:disable:next function_body_length
    func resolveGenerationParameters(from configuration: TokensConfiguration) throws -> TokensGenerationParameters {

        let file = try configuration.file.map { fileConfiguration in
            guard let accessToken = accessTokenResolver.resolveAccessToken(from: configuration.accessToken) else {
                throw GenerationParametersError.invalidAccessToken
            }

            return FileParameters(
                key: fileConfiguration.key,
                version: fileConfiguration.version,
                accessToken: accessToken
            )
        }

        let remoteFile = try configuration.remoteRepoConfig.map { remoteFileConfiguration in
            guard
                let accessToken = accessTokenResolver.resolveAccessToken(from: remoteFileConfiguration.accessToken)
            else {
                throw GenerationParametersError.invalidGitHubAccessToken
            }

            return RemoteFileParameters(
                owner: remoteFileConfiguration.owner,
                repo: remoteFileConfiguration.repo,
                branch: remoteFileConfiguration.branch,
                filePath: remoteFileConfiguration.filePath,
                accessToken: accessToken
            )
        }

        if file.isNil && remoteFile.isNil {
            throw GenerationParametersError.invalidFileConfiguration
        }

        let colorRenderParameters = renderParametersResolver.resolveRenderParameters(
            templates: configuration.templates?.colors,
            defaultTemplateType: .native(name: "ColorTokens")
        )

        let baseColorRenderParameters = renderParametersResolver.resolveRenderParameters(
            templates: configuration.templates?.baseColors,
            defaultTemplateType: .native(name: "BaseColorTokens")
        )

        let fontFamilyRenderParameters = renderParametersResolver.resolveRenderParameters(
            templates: configuration.templates?.fontFamilies,
            defaultTemplateType: .native(name: "FontFamilyTokens")
        )

        let typographyRenderParameters = renderParametersResolver.resolveRenderParameters(
            templates: configuration.templates?.typographies,
            defaultTemplateType: .native(name: "TypographyTokens")
        )

        let boxShadowRenderParameters = renderParametersResolver.resolveRenderParameters(
            templates: configuration.templates?.boxShadows,
            defaultTemplateType: .native(name: "BoxShadowTokens")
        )

        let themeRenderParameters = renderParametersResolver.resolveRenderParameters(
            templates: configuration.templates?.theme,
            defaultTemplateType: .native(name: "Theme")
        )

        let spacingRenderParameters = renderParametersResolver.resolveRenderParameters(
            templates: configuration.templates?.spacing,
            defaultTemplateType: .native(name: "SpacingTokens")
        )

        let borderRenderParameters = renderParametersResolver.resolveRenderParameters(
            templates: configuration.templates?.borders,
            defaultTemplateType: .native(name: "BorderTokens")
        )

        return TokensGenerationParameters(
            file: file,
            remoteFile: remoteFile,
            tokens: TokensGenerationParameters.TokensParameters(
                colorRenderParameters: colorRenderParameters,
                baseColorRenderParameters: baseColorRenderParameters,
                fontFamilyRenderParameters: fontFamilyRenderParameters,
                typographyRenderParameters: typographyRenderParameters,
                boxShadowRenderParameters: boxShadowRenderParameters,
                themeRenderParameters: themeRenderParameters,
                spacingRenderParameters: spacingRenderParameters,
                bordersRenderParameters: borderRenderParameters
            )
        )
    }
}
