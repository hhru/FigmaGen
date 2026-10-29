import Foundation

/// Маппер наборов токенов FigmaGen коллекциям манифеста SXL Studio.
struct W3CTokenSetsMapping: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case core
        case semantic
        case colors
        case typography
        case themes
    }

    // MARK: - Instance Properties

    let core: String
    let semantic: String
    let colors: String
    let typography: String
    let themes: String

    // MARK: - Initializers

    init(
        core: String?,
        semantic: String?,
        colors: String?,
        typography: String?,
        themes: String?
    ) {
        self.core = core ?? "core"
        self.semantic = semantic ?? "semantic"
        self.colors = colors ?? "colors"
        self.typography = typography ?? "typography"
        self.themes = themes ?? "themes"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        core = try container.decodeIfPresent(forKey: .core) ?? "core"
        semantic = try container.decodeIfPresent(forKey: .semantic) ?? "semantic"
        colors = try container.decodeIfPresent(forKey: .colors) ?? "colors"
        typography = try container.decodeIfPresent(forKey: .typography) ?? "typography"
        themes = try container.decodeIfPresent(forKey: .themes) ?? "themes"
    }
}
