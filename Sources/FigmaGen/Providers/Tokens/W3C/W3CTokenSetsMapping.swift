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
        core: String? = nil,
        semantic: String? = nil,
        colors: String? = nil,
        typography: String? = nil,
        themes: String? = nil
    ) {
        self.core = core ?? "core"
        self.semantic = semantic ?? "common"
        self.colors = colors ?? "palette"
        self.typography = typography ?? "typography"
        self.themes = themes ?? "themes"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.init(
            core: try container.decodeIfPresent(forKey: .core),
            semantic: try container.decodeIfPresent(forKey: .semantic),
            colors: try container.decodeIfPresent(forKey: .colors),
            typography: try container.decodeIfPresent(forKey: .typography),
            themes: try container.decodeIfPresent(forKey: .themes)
        )
    }
}
