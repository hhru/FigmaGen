import Foundation
import FigmaGenTools

struct TokensTemplateConfiguration {

    // MARK: - Nested Types

    struct Template {

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

    let colors: [Template]?
    let baseColors: [Template]?
    let fontFamilies: [Template]?
    let typographies: [Template]?
    let boxShadows: [Template]?
    let theme: [Template]?
    let spacing: [Template]?
}

// MARK: - Decodable

extension TokensTemplateConfiguration: Decodable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case colors
        case baseColors
        case fontFamilies
        case typographies
        case boxShadows
        case theme
        case spacing
    }

    private struct TemplateWrapper: Decodable {

        // MARK: - Instance Properties

        let templates: [Template]?

        // MARK: - Initializers

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if container.decodeNil() {
                self.templates = nil
            } else if let singleValue = try? container.decode(Template.self) {
                self.templates = [singleValue]
            } else {
                self.templates = try container.decode([Template].self)
            }
        }
    }

    // MARK: - Initializers

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.colors = try container.decode(TemplateWrapper.self, forKey: .colors).templates
        self.baseColors = try container.decode(TemplateWrapper.self, forKey: .baseColors).templates
        self.fontFamilies = try container.decode(TemplateWrapper.self, forKey: .fontFamilies).templates
        self.typographies = try container.decode(TemplateWrapper.self, forKey: .typographies).templates
        self.boxShadows = try container.decode(TemplateWrapper.self, forKey: .boxShadows).templates
        self.theme = try container.decode(TemplateWrapper.self, forKey: .theme).templates
        self.spacing = try container.decode(TemplateWrapper.self, forKey: .spacing).templates
    }
}

// MARK: -

extension TokensTemplateConfiguration.Template: Decodable {

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
