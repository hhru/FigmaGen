import Foundation

struct TokenValues: Codable, Hashable {

    // MARK: - Instance Properties

    let core: [TokenValue]
    let semantic: [TokenValue]
    let colors: [TokenValue]
    let typography: [TokenValue]
    let day: [TokenValue]
    let night: [TokenValue]
}
