import Foundation
import FigmaGenTools

struct GenerationConfiguration: Decodable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case file
        case accessToken
        case templates

        // TODO [MOB-35468] Remove template, templateOptions, destination
        case template
        case templateOptions
        case destination
    }

    // MARK: - Instance Properties

    let file: FileConfiguration?
    let accessToken: AccessTokenConfiguration?
    let templates: [TemplateConfiguration]?

    // TODO [MOB-35468] Remove template, templateOptions, destination
    let template: String?
    let templateOptions: [String: Any]?
    let destination: String?

    // MARK: - Initializers

    init(
        file: FileConfiguration?,
        accessToken: AccessTokenConfiguration?,
        templates: [TemplateConfiguration]?,
        // TODO [MOB-35468] Remove template, templateOptions, destination
        template: String?,
        templateOptions: [String: Any]?,
        destination: String?
    ) {
        self.file = file
        self.accessToken = accessToken
        self.templates = templates

        // TODO [MOB-35468] Remove template, templateOptions, destination
        self.template = template
        self.templateOptions = templateOptions
        self.destination = destination
    }

    init(from decoder: Decoder) throws {
        let base = try BaseConfiguration(from: decoder)

        file = base.file
        accessToken = base.accessToken

        let container = try decoder.container(keyedBy: CodingKeys.self)

        templates = try container.decodeIfPresent(TemplateConfigurationWrapper.self, forKey: .templates)?.templates

        // TODO [MOB-35468] Remove template, templateOptions, destination
        template = try container.decodeIfPresent(forKey: .template)

        templateOptions = try container
            .decodeIfPresent([String: AnyCodable].self, forKey: .templateOptions)?
            .mapValues { $0.value }

        destination = try container.decodeIfPresent(forKey: .destination)
    }

    // MARK: - Instance Methods

    func resolve(base: BaseConfiguration?) -> Self {
        guard let base else {
            return self
        }

        return Self(
            file: file ?? base.file,
            accessToken: accessToken ?? base.accessToken,
            templates: templates,
            // TODO [MOB-35468] Remove template, templateOptions, destination
            template: template,
            templateOptions: templateOptions,
            destination: destination
        )
    }
}
