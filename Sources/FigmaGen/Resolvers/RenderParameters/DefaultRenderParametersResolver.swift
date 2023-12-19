import Foundation

final class DefaultRenderParametersResolver: RenderParametersResolver {

    // MARK: - Instance Methods

    private func resolveTemplateType(
        template: TemplateConfiguration,
        defaultTemplateType: RenderTemplateType
    ) -> RenderTemplateType {
        if let templatePath = template.template {
            return .custom(path: templatePath)
        }

        return defaultTemplateType
    }

    private func resolveDestination(
        template: TemplateConfiguration,
        defaultDestination: RenderDestination
    ) -> RenderDestination {
        if let destinationPath = template.destination {
            return .file(path: destinationPath)
        }

        return defaultDestination
    }

    func resolveRenderParameters(
        templates: [TemplateConfiguration]?,
        defaultTemplateType: RenderTemplateType,
        defaultDestination: RenderDestination
    ) -> [RenderParameters] {
        let defaultRenderParameters = RenderParameters(
            template: RenderTemplate(
                type: defaultTemplateType,
                options: [:]
            ),
            destination: defaultDestination
        )

        guard let templates else {
            return [defaultRenderParameters]
        }

        return templates.map { template in
            let templateType = resolveTemplateType(
                template: template,
                defaultTemplateType: defaultTemplateType
            )

            let destination = resolveDestination(
                template: template,
                defaultDestination: defaultDestination
            )

            let template = RenderTemplate(
                type: templateType,
                options: template.templateOptions ?? [:]
            )

            return RenderParameters(template: template, destination: destination)
        }
    }
}
