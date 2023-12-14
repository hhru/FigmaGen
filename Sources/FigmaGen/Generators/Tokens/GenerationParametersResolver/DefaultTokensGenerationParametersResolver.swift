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
        template: Template,
        nativeTemplateName: String
    ) -> RenderTemplateType {
        if let templatePath = template.template {
            return .custom(path: templatePath)
        }

        return .native(name: nativeTemplateName)
    }

    private func resolveDestination(template: Template) -> RenderDestination {
        if let destinationPath = template.destination {
            return .file(path: destinationPath)
        }

        return .console
    }

    private func resolveRenderParameters(
        templates: [Template]?,
        nativeTemplateName: String
    ) -> [RenderParameters]? {
        guard let templateConfigurations = templates else {
            return nil
        }

        return templateConfigurations.map { template -> RenderParameters in
            let templateType = resolveTemplateType(
                template: template,
                nativeTemplateName: nativeTemplateName
            )

            let destination = resolveDestination(template: template)

            let template = RenderTemplate(
                type: templateType,
                options: template.templateOptions ?? [:]
            )

            return RenderParameters(template: template, destination: destination)
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

        let colorRenderParameters = resolveRenderParameters(
            templates: configuration.templates?.colors,
            nativeTemplateName: "ColorTokens"
        )

        let baseColorRenderParameters = resolveRenderParameters(
            templates: configuration.templates?.baseColors,
            nativeTemplateName: "BaseColorTokens"
        )

        let fontFamilyRenderParameters = resolveRenderParameters(
            templates: configuration.templates?.fontFamilies,
            nativeTemplateName: "FontFamilyTokens"
        )

        let typographyRenderParameters = resolveRenderParameters(
            templates: configuration.templates?.typographies,
            nativeTemplateName: "TypographyTokens"
        )

        let boxShadowRenderParameters = resolveRenderParameters(
            templates: configuration.templates?.boxShadows,
            nativeTemplateName: "BoxShadowTokens"
        )

        let themeRenderParameters = resolveRenderParameters(
            templates: configuration.templates?.theme,
            nativeTemplateName: "Theme"
        )

        let spacingRenderParameters = resolveRenderParameters(
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
