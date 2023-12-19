import Foundation
import FigmaGenTools
import PromiseKit

final class DefaultImagesGenerator: ImagesGenerator, GenerationParametersResolving {

    // MARK: - Instance Properties

    let imagesProvider: ImagesProvider
    let templateRenderer: TemplateRenderer
    let accessTokenResolver: AccessTokenResolver
    let renderParametersResolver: RenderParametersResolver

    let defaultTemplateType = RenderTemplateType.native(name: "Images")
    let defaultDestination = RenderDestination.console

    // MARK: - Initializers

    init(
        imagesProvider: ImagesProvider,
        templateRenderer: TemplateRenderer,
        accessTokenResolver: AccessTokenResolver,
        renderParametersResolver: RenderParametersResolver
    ) {
        self.imagesProvider = imagesProvider
        self.templateRenderer = templateRenderer
        self.accessTokenResolver = accessTokenResolver
        self.renderParametersResolver = renderParametersResolver
    }

    // MARK: - Instance Methods

    private func generate(parameters: GenerationParameters, imagesParameters: ImagesParameters) -> Promise<Void> {
        firstly {
            self.imagesProvider.fetchImages(
                from: parameters.file,
                nodes: parameters.nodes,
                parameters: imagesParameters
            )
        }.map { imageSets in
            ImagesContext(
                imageSets: imageSets.sorted { $0.name.lowercased() < $1.name.lowercased() }
            )
        }.done { context in
            try parameters.renderParameters.forEach { params in
                try self.templateRenderer.renderTemplate(
                    params.template,
                    to: params.destination,
                    context: context
                )
            }
        }
    }

    // MARK: -

    func generate(configuration: ImagesConfiguration) -> Promise<Void> {
        perform(on: DispatchQueue.global(qos: .userInitiated)) {
            try self.resolveGenerationParameters(from: configuration.generatation)
        }.then { parameters in
            self.generate(parameters: parameters, imagesParameters: configuration.imagesParameters)
        }
    }
}

extension ImagesConfiguration {

    // MARK: - Instance Properties

    fileprivate var imagesParameters: ImagesParameters {
        ImagesParameters(
            format: format,
            scales: scales,
            assets: assets,
            resources: resources,
            postProcessor: postProcessor,
            onlyExportables: onlyExportables,
            useAbsoluteBounds: useAbsoluteBounds,
            preserveVectorData: preserveVectorData,
            renderAs: renderAs,
            groupByFrame: groupByFrame,
            groupByComponentSet: groupByComponentSet,
            namingStyle: namingStyle
        )
    }
}
