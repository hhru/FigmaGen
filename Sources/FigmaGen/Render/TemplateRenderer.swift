import Foundation

protocol TemplateRenderer {

    // MARK: - Instance Methods

    func renderTemplate(
        _ template: RenderTemplate,
        to destination: RenderDestination,
        context: [String: Any]
    ) throws

    func renderTemplate<Context: Encodable>(
        _ template: RenderTemplate,
        to destination: RenderDestination,
        context: Context
    ) throws
}
