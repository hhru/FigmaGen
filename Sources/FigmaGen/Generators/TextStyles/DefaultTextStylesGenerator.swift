import Foundation
import FigmaGenTools
import PromiseKit

final class DefaultTextStylesGenerator: TextStylesGenerator, GenerationParametersResolving {

    // MARK: - Instance Properties

    let textStylesProvider: TextStylesProvider
    let templateRenderer: TemplateRenderer
    let accessTokenResolver: AccessTokenResolver
    let renderParametersResolver: RenderParametersResolver

    let defaultTemplateType = RenderTemplateType.native(name: "TextStyles")
    let defaultDestination = RenderDestination.console

    // MARK: - Initializers

    init(
        textStylesProvider: TextStylesProvider,
        templateRenderer: TemplateRenderer,
        accessTokenResolver: AccessTokenResolver,
        renderParametersResolver: RenderParametersResolver
    ) {
        self.textStylesProvider = textStylesProvider
        self.templateRenderer = templateRenderer
        self.accessTokenResolver = accessTokenResolver
        self.renderParametersResolver = renderParametersResolver
    }

    // MARK: - Instance Methods

    private func generate(parameters: GenerationParameters) -> Promise<Void> {
        firstly {
            self.textStylesProvider.fetchTextStyles(from: parameters.file, nodes: parameters.nodes)
        }.map { textStyles in
            TextStylesContext(textStyles: textStyles)
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

    func generate(configuration: TextStylesConfiguration) -> Promise<Void> {
        perform(on: DispatchQueue.global(qos: .userInitiated)) {
            try self.resolveGenerationParameters(from: configuration)
        }.then { parameters in
            self.generate(parameters: parameters)
        }
    }
}
