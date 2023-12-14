import Foundation
import FigmaGenTools

struct TokensTemplateConfiguration {

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

    // MARK: - Initializers

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.colors = try container.decodeIfPresent(TemplateWrapper.self, forKey: .colors)?.templates
        self.baseColors = try container.decodeIfPresent(TemplateWrapper.self, forKey: .baseColors)?.templates
        self.fontFamilies = try container.decodeIfPresent(TemplateWrapper.self, forKey: .fontFamilies)?.templates
        self.typographies = try container.decodeIfPresent(TemplateWrapper.self, forKey: .typographies)?.templates
        self.boxShadows = try container.decodeIfPresent(TemplateWrapper.self, forKey: .boxShadows)?.templates
        self.theme = try container.decodeIfPresent(TemplateWrapper.self, forKey: .theme)?.templates
        self.spacing = try container.decodeIfPresent(TemplateWrapper.self, forKey: .spacing)?.templates
    }
}
