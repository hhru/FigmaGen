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

    private func resolveColorTemplateType(configuration: TokensConfiguration) -> RenderTemplateType {
        if let templatePath = configuration.templates?.color?.template {
            return .custom(path: templatePath)
        }

        return .native(name: "ColorTokens")
    }

    private func resolveColorDestination(configuration: TokensConfiguration) -> RenderDestination {
        if let destinationPath = configuration.templates?.color?.destination {
            return .file(path: destinationPath)
        }

        return .console
    }

    private func resolveColorRenderParameters(configuration: TokensConfiguration) -> RenderParameters {
        let templateType = resolveColorTemplateType(configuration: configuration)
        let destination = resolveColorDestination(configuration: configuration)

        let template = RenderTemplate(
            type: templateType,
            options: configuration.templates?.color?.templateOptions ?? [:]
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

        let colorRender = resolveColorRenderParameters(configuration: configuration)

        return TokensGenerationParameters(
            file: file,
            tokens: TokensGenerationParameters.TokensParameters(
                colorRender: colorRender
            )
        )
    }
}
