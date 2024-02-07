import Foundation

struct TokenValues: Hashable {

    // MARK: - Instance Properties

    let core: [TokenValue]
    let semantic: [TokenValue]
    let colors: [TokenValue]
    let typography: [TokenValue]
    let hhDay: [TokenValue]
    let hhNight: [TokenValue]
    let zpDay: [TokenValue]

    // MARK: - Instance Properties

    /// Возвращает набор токенов для определенной темы.
    /// Для undefined возвращается полный набор токенов. Нужен для Spacer, Font и других независимых от темы параметров.
    func getThemeTokenValues(theme: Theme) -> [TokenValue] {
        switch theme {
        case .day:
            return [hhDay, core, semantic, colors, typography].flatMap { $0 }

        case .night:
            return [hhNight, core, semantic, colors, typography].flatMap { $0 }

        case .undefined:
            return [core, semantic, colors, typography, hhDay, hhNight].flatMap { $0 }
        }
    }
}

// MARK: - Codable

extension TokenValues: Codable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {

        // MARK: - Enumeration Cases

        case core
        case semantic
        case colors
        case typography
        case hhDay = "hh-day"
        case hhNight = "hh-night"
        case zpDay = "zp-day"
    }
}
