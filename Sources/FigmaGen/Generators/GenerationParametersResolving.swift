import Foundation

protocol GenerationParametersResolving {

    // MARK: - Instance Properties

    var accessTokenResolver: AccessTokenResolver { get }
    var renderParametersResolver: RenderParametersResolver { get }

    // MARK: - Instance Properties

    var defaultTemplateType: RenderTemplateType { get }
    var defaultDestination: RenderDestination { get }

    // MARK: - Instance Methods

    func resolveGenerationParameters(from configuration: GenerationConfiguration) throws -> GenerationParameters
}

extension GenerationParametersResolving {

    // MARK: -

    func resolveGenerationParameters(from configuration: GenerationConfiguration) throws -> GenerationParameters {
        guard let fileConfiguration = configuration.file else {
            throw GenerationParametersError.invalidFileConfiguration
        }

        let accessToken = accessTokenResolver.resolveAccessToken(from: configuration.accessToken)

        guard let accessToken, !accessToken.isEmpty else {
            throw GenerationParametersError.invalidAccessToken
        }

        let file = FileParameters(
            key: fileConfiguration.key,
            version: fileConfiguration.version,
            accessToken: accessToken
        )

        let nodes = NodesParameters(
            includedIDs: fileConfiguration.includedNodes,
            excludedIDs: fileConfiguration.excludedNodes
        )

        let renderParametersList = renderParametersResolver.resolveRenderParameters(
            templates: configuration.templates,
            defaultTemplateType: defaultTemplateType,
            defaultDestination: defaultDestination
        )

        return GenerationParameters(
            file: file,
            nodes: nodes,
            renderParameters: renderParametersList
        )
    }
}
