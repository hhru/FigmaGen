import Foundation

protocol RenderParametersResolver {

    func resolveRenderParameters(
        templates: [TemplateConfiguration]?,
        defaultTemplateType: RenderTemplateType,
        defaultDestination: RenderDestination
    ) -> [RenderParameters]?

}

extension RenderParametersResolver {

    func resolveRenderParameters(
        templates: [TemplateConfiguration]?,
        defaultTemplateType: RenderTemplateType,
        defaultDestination: RenderDestination = .console
    ) -> [RenderParameters]? {
        resolveRenderParameters(
            templates: templates,
            defaultTemplateType: defaultTemplateType,
            defaultDestination: defaultDestination
        )
    }

}