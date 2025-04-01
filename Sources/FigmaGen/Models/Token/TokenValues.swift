import Foundation

struct TokenValues: Hashable {

    // MARK: - Instance Properties

    let core: [TokenValue]
    let semantic: [TokenValue]
    let colors: [TokenValue]
    let typography: [TokenValue]
    let themedTokens: [Theme: [TokenValue]]
}

// MARK: - Codable

extension TokenValues: Codable {

    private enum CodingKeys: String, CodingKey, CaseIterable {

        // MARK: - Enumeration Cases

        case core
        case semantic
        case colors
        case typography
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let staticKeys = CodingKeys.allCases.map { $0.rawValue }
        let themedContainer = try decoder.container(keyedBy: AnyKey.self)

        self.core = try container.decode(forKey: .core)
        self.semantic = try container.decode(forKey: .semantic)
        self.colors = try container.decode(forKey: .colors)
        self.typography = try container.decode(forKey: .typography)
        self.themedTokens = Dictionary(
            uniqueKeysWithValues: try themedContainer
                .allKeys
                .filter { key in
                    !staticKeys.contains(key.stringValue)
                }
                .map { key in
                    let tokens = try themedContainer.decode([TokenValue].self, forKey: key)
                    let theme = Theme(key.stringValue)
                    return (theme, tokens)
                }
        )
    }
}

extension TokenValues {

    func tokens(for theme: Theme) -> [TokenValue] {
        themedTokens[theme] ?? []
    }

    /// Возвращает набор токенов для определенной темы.
    /// Для undefined возвращается полный набор токенов. Нужен для Spacer, Font и других независимых от темы параметров.
    func getThemeTokenValues(theme: Theme?) -> [TokenValue] {
        let allThemedTokens = themedTokens.values.flatMap { $0 }
        let themeTokens = theme.map { themedTokens[$0] ?? [] } ?? allThemedTokens
        let tokens = [core, semantic, colors, typography, themeTokens]

        return tokens.flatMap { $0 }
    }
}
