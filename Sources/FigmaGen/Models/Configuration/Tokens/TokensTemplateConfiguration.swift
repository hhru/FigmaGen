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

        colors = try container.decodeIfPresent(TemplateConfigurationWrapper.self, forKey: .colors)?.templates
        baseColors = try container.decodeIfPresent(TemplateConfigurationWrapper.self, forKey: .baseColors)?.templates
        fontFamilies = try container.decodeIfPresent(
            TemplateConfigurationWrapper.self,
            forKey: .fontFamilies
        )?.templates
        typographies = try container.decodeIfPresent(
            TemplateConfigurationWrapper.self,
            forKey: .typographies
        )?.templates
        boxShadows = try container.decodeIfPresent(TemplateConfigurationWrapper.self, forKey: .boxShadows)?.templates
        theme = try container.decodeIfPresent(TemplateConfigurationWrapper.self, forKey: .theme)?.templates
        spacing = try container.decodeIfPresent(TemplateConfigurationWrapper.self, forKey: .spacing)?.templates
    }
}
