import Foundation

struct FigmaComponent: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case key
        case name
        case description
        case componentSetID = "componentSetId"
    }

    // MARK: - Instance Properties

    let key: String?
    let name: String?
    let description: String?
    let componentSetID: String?
}
