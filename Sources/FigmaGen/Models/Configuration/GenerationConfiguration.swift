import Foundation
import FigmaGenTools

struct GenerationConfiguration: Decodable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case file
        case accessToken
        case templates
    }

    // MARK: - Instance Properties

    let file: FileConfiguration?
    let accessToken: AccessTokenConfiguration?
    let templates: [TemplateConfiguration]?

    // MARK: - Initializers

    init(
        file: FileConfiguration?,
        accessToken: AccessTokenConfiguration?,
        templates: [TemplateConfiguration]?
    ) {
        self.file = file
        self.accessToken = accessToken
        self.templates = templates
    }

    init(from decoder: Decoder) throws {
        let base = try BaseConfiguration(from: decoder)

        file = base.file
        accessToken = base.accessToken

        let container = try decoder.container(keyedBy: CodingKeys.self)

        templates = try container.decodeIfPresent(TemplateConfigurationWrapper.self, forKey: .templates)?.templates
    }

    // MARK: - Instance Methods

    func resolve(base: BaseConfiguration?) -> Self {
        guard let base else {
            return self
        }

        return Self(
            file: file ?? base.file,
            accessToken: accessToken ?? base.accessToken,
            templates: templates
        )
    }
}
