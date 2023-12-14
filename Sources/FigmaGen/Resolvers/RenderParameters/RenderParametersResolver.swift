import Foundation

protocol RenderParametersResolver {

    func resolveRenderParameters(
        templates: [TemplateConfiguration]?,
        nativeTemplateName: String
    ) -> [RenderParameters]?

}
