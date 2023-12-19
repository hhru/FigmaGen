import Foundation
import FigmaGenTools
import PromiseKit

final class DefaultColorStylesGenerator: ColorStylesGenerator, GenerationParametersResolving {

    // MARK: - Instance Properties

    let colorStylesProvider: ColorStylesProvider
    let templateRenderer: TemplateRenderer
    let accessTokenResolver: AccessTokenResolver
    let renderParametersResolver: RenderParametersResolver

    let defaultTemplateType = RenderTemplateType.native(name: "ColorStyles")
    let defaultDestination = RenderDestination.console

    // MARK: - Initializers

    init(
        colorStylesProvider: ColorStylesProvider,
        templateRenderer: TemplateRenderer,
        accessTokenResolver: AccessTokenResolver,
        renderParametersResolver: RenderParametersResolver
    ) {
        self.colorStylesProvider = colorStylesProvider
        self.templateRenderer = templateRenderer
        self.accessTokenResolver = accessTokenResolver
        self.renderParametersResolver = renderParametersResolver
    }

    // MARK: - Instance Methods

    private func generate(parameters: GenerationParameters, assets: String?) -> Promise<Void> {
        firstly {
            colorStylesProvider.fetchColorStyles(
                from: parameters.file,
                nodes: parameters.nodes,
                assets: assets
            )
        }.map { colorStyles in
            ColorStylesContext(colorStyles: colorStyles)
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

    func generate(configuration: ColorStylesConfiguration) -> Promise<Void> {
        perform(on: DispatchQueue.global(qos: .userInitiated)) {
            try self.resolveGenerationParameters(from: configuration.generation)
        }.then { parameters in
            self.generate(parameters: parameters, assets: configuration.assets)
        }
    }
}
