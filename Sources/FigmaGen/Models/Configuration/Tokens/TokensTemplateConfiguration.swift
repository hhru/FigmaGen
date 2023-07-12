import Foundation
import FigmaGenTools

struct TokensTemplateConfiguration: Decodable {

    // MARK: - Nested Types

    struct Template: Decodable {

        // MARK: - Instance Properties

        let template: String?
        let templateOptions: [String: Any]?
        let destination: String?

        // MARK: - Initializers

        init(
            template: String?,
            templateOptions: [String: Any]?,
            destination: String?
        ) {
            self.template = template
            self.templateOptions = templateOptions
            self.destination = destination
        }
    }

    // MARK: - Instance Properties

    let color: Template?
}

extension TokensTemplateConfiguration.Template {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case template
        case templateOptions
        case destination
    }

    // MARK: - Initializers

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.template = try container.decodeIfPresent(forKey: .template)

        self.templateOptions = try container
            .decodeIfPresent([String: AnyCodable].self, forKey: .templateOptions)?
            .mapValues { $0.value }

        self.destination = try container.decodeIfPresent(forKey: .destination)
    }
}
