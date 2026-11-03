import Foundation

struct Transition {

    // MARK: - Instance Properties

    let path: [String]
    let x1: String
    let y1: String
    let x2: String
    let y2: String

    /// Длительность в секундах. `nil`, если значение не удалось разрешить.
    let duration: Double?
    let durationMs: String?

    /// Задержка в секундах. `nil`, если задержки нет или значение не удалось разрешить.
    let delay: Double?
    let delayMs: String?
    
    let description: String?
}
