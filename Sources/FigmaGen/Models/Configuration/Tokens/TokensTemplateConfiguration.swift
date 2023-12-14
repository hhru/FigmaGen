import Foundation
import FigmaGenTools

struct TokensTemplateConfiguration {

    // MARK: - Instance Properties

    let colors: [TemplateConfiguration]?
    let baseColors: [TemplateConfiguration]?
    let fontFamilies: [TemplateConfiguration]?
    let typographies: [TemplateConfiguration]?
    let boxShadows: [TemplateConfiguration]?
    let theme: [TemplateConfiguration]?
    let spacing: [TemplateConfiguration]?
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

    // MARK: - Initializers

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.colors = try container.decodeIfPresent(TemplateConfigurationWrapper.self, forKey: .colors)?.templates
        self.baseColors = try container.decodeIfPresent(TemplateConfigurationWrapper.self, forKey: .baseColors)?.templates
        self.fontFamilies = try container.decodeIfPresent(TemplateConfigurationWrapper.self, forKey: .fontFamilies)?.templates
        self.typographies = try container.decodeIfPresent(TemplateConfigurationWrapper.self, forKey: .typographies)?.templates
        self.boxShadows = try container.decodeIfPresent(TemplateConfigurationWrapper.self, forKey: .boxShadows)?.templates
        self.theme = try container.decodeIfPresent(TemplateConfigurationWrapper.self, forKey: .theme)?.templates
        self.spacing = try container.decodeIfPresent(TemplateConfigurationWrapper.self, forKey: .spacing)?.templates
    }
}
