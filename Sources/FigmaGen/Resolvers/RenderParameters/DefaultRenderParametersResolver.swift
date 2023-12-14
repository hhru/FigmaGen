import Foundation

final class DefaultRenderParametersResolver: RenderParametersResolver {

    // MARK: - Instance Methods

    private func resolveTemplateType(
        template: TemplateConfiguration,
        nativeTemplateName: String
    ) -> RenderTemplateType {
        if let templatePath = template.template {
            return .custom(path: templatePath)
        }

        return .native(name: nativeTemplateName)
    }

    private func resolveDestination(template: TemplateConfiguration) -> RenderDestination {
        if let destinationPath = template.destination {
            return .file(path: destinationPath)
        }

        return .console
    }

    func resolveRenderParameters(
        templates: [TemplateConfiguration]?,
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

}