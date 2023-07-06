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

    var all: [TokenValue] {
        [core, semantic, colors, typography, day, night].flatMap { $0 }
    }
}
