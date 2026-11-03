import Foundation

struct SXLTokensCollection: Decodable, Hashable {

    private enum CodingKeys: String, CodingKey {
        case name
        case enabled
        case modes
    }

    // MARK: - Instance Properties

    let name: String
    let isEnabled: Bool
    let modes: [SXLTokensMode]

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decodeIfPresent(String.self, forKey: .name) ?? "unknown"
        isEnabled = try container.decodeIfPresent(Bool.self, forKey: .enabled) ?? false
        modes = try container.decodeIfPresent([SXLTokensMode].self, forKey: .modes) ?? []
     }
}
