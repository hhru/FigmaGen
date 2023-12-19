import Foundation

struct TemplateConfigurationWrapper: Decodable {

    // MARK: - Instance Properties

    let templates: [TemplateConfiguration]?

    // MARK: - Initializers

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self.templates = nil
        } else if let singleValue = try? container.decode(TemplateConfiguration.self) {
            self.templates = [singleValue]
        } else {
            self.templates = try container.decode([TemplateConfiguration].self)
        }
    }
}
