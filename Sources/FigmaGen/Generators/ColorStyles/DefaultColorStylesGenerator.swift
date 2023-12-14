import Foundation
import FigmaGenTools
import PromiseKit

final class DefaultColorStylesGenerator: ColorStylesGenerator, GenerationParametersResolving {

    // MARK: - Instance Properties

    let colorStylesProvider: ColorStylesProvider
    let templateRenderer: TemplateRenderer
    let accessTokenResolver: AccessTokenResolver
    let defaultTemplateType = RenderTemplateType.native(name: "ColorStyles")
    let defaultDestination = RenderDestination.console

    // MARK: - Initializers

    init(
        colorStylesProvider: ColorStylesProvider,
        templateRenderer: TemplateRenderer,
        accessTokenResolver: AccessTokenResolver
    ) {
        self.colorStylesProvider = colorStylesProvider
        self.templateRenderer = templateRenderer
        self.accessTokenResolver = accessTokenResolver
    }

    // MARK: - Instance Methods

    private func generate(parameters: GenerationParameters, assets: String?) -> Promise<Void> {
        firstly {
            self.colorStylesProvider.fetchColorStyles(
                from: parameters.file,
                nodes: parameters.nodes,
                assets: assets
            )
        }.map { colorStyles in
            ColorStylesContext(colorStyles: colorStyles)
        }.done { context in
            try self.templateRenderer.renderTemplate(
                parameters.render.template,
                to: parameters.render.destination,
                context: context
            )
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
