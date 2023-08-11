import Foundation

final class DefaultTokensGenerationParametersResolver: TokensGenerationParametersResolver {

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

    private func resolveTemplateType(
        template: TokensTemplateConfiguration.Template,
        nativeTemplateName: String
    ) -> RenderTemplateType {
        if let templatePath = template.template {
            return .custom(path: templatePath)
        }

        return .native(name: nativeTemplateName)
    }

    private func resolveDestination(template: TokensTemplateConfiguration.Template) -> RenderDestination {
        if let destinationPath = template.destination {
            return .file(path: destinationPath)
        }

        return .console
    }

    private func resolveRenderParameters(
        template: TokensTemplateConfiguration.Template?,
        nativeTemplateName: String
    ) -> RenderParameters? {
        guard let templateConfiguration = template else {
            return nil
        }

        let templateType = resolveTemplateType(
            template: templateConfiguration,
            nativeTemplateName: nativeTemplateName
        )

        let destination = resolveDestination(template: templateConfiguration)

        let template = RenderTemplate(
            type: templateType,
            options: templateConfiguration.templateOptions ?? [:]
        )

        return RenderParameters(template: template, destination: destination)
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

        let colorRender = resolveRenderParameters(
            template: configuration.templates?.colors,
            nativeTemplateName: "ColorTokens"
        )

        let baseColorRender = resolveRenderParameters(
            template: configuration.templates?.baseColors,
            nativeTemplateName: "BaseColorTokens"
        )

        let fontFamilyRender = resolveRenderParameters(
            template: configuration.templates?.fontFamilies,
            nativeTemplateName: "FontFamilyTokens"
        )

        let typographyRender = resolveRenderParameters(
            template: configuration.templates?.typographies,
            nativeTemplateName: "TypographyTokens"
        )

        let boxShadowRender = resolveRenderParameters(
            template: configuration.templates?.boxShadows,
            nativeTemplateName: "BoxShadowTokens"
        )

        let themeRender = resolveRenderParameters(
            template: configuration.templates?.theme,
            nativeTemplateName: "Theme"
        )

        let spacingRender = resolveRenderParameters(
            template: configuration.templates?.spacing,
            nativeTemplateName: "Spacing"
        )

        return TokensGenerationParameters(
            file: file,
            tokens: TokensGenerationParameters.TokensParameters(
                colorRender: colorRender,
                baseColorRender: baseColorRender,
                fontFamilyRender: fontFamilyRender,
                typographyRender: typographyRender,
                boxShadowRender: boxShadowRender,
                themeRender: themeRender,
                spacingRender: spacingRender
            )
        )
    }
}
