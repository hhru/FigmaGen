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
        template: TokensTemplateConfiguration.Template?,
        nativeTemplateName: String
    ) -> RenderTemplateType {
        if let templatePath = template?.template {
            return .custom(path: templatePath)
        }

        return .native(name: nativeTemplateName)
    }

    private func resolveDestination(template: TokensTemplateConfiguration.Template?) -> RenderDestination {
        if let destinationPath = template?.destination {
            return .file(path: destinationPath)
        }

        return .console
    }

    private func resolveRenderParameters(
        template: TokensTemplateConfiguration.Template?,
        nativeTemplateName: String
    ) -> RenderParameters {
        let templateType = resolveTemplateType(
            template: template,
            nativeTemplateName: nativeTemplateName
        )

        let destination = resolveDestination(template: template)

        let template = RenderTemplate(
            type: templateType,
            options: template?.templateOptions ?? [:]
        )

        return RenderParameters(template: template, destination: destination)
    }

    // MARK: -

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
            template: configuration.templates?.color,
            nativeTemplateName: "ColorTokens"
        )

        let baseColorRender = resolveRenderParameters(
            template: configuration.templates?.baseColor,
            nativeTemplateName: "BaseColorTokens"
        )

        return TokensGenerationParameters(
            file: file,
            tokens: TokensGenerationParameters.TokensParameters(
                colorRender: colorRender,
                baseColorRender: baseColorRender
            )
        )
    }
}
