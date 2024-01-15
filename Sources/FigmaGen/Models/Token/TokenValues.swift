import Foundation

struct TokenValues: Codable, Hashable {

    // MARK: - Instance Properties

    let core: [TokenValue]
    let semantic: [TokenValue]
    let colors: [TokenValue]
    let typography: [TokenValue]
    let day: [TokenValue]
    let night: [TokenValue]

    // MARK: - Instance Properties
    
    // Возвращает набор токенов для определенной темы.
    // Для undefined возвращается полный набор токенов. Нужен для Spacer, Font и других независимых от темы параметров.
    func getThemeTokenValues(theme: Theme) -> [TokenValue] {
        switch theme {
        case .day: return [day, core, semantic, colors, typography].flatMap { $0 }
        case .night: return [night, core, semantic, colors, typography].flatMap { $0 }
        case .undefined: return [core, semantic, colors, typography, day, night].flatMap { $0 }
        }
    }
}
