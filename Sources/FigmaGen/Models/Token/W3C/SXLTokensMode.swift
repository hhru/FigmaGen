import Foundation

struct SXLTokensMode: Decodable, Hashable {

    private enum CodingKeys: String, CodingKey {
        case name
        case enabled
        case files
    }

    // MARK: - Instance Properties

    let name: String
    let isEnabled: Bool

    /// Пути к файлам относительно манифеста и их статус (`enabled`, `source`, `disabled`).
    let files: [String: String]

    var enabledFiles: [String] {
        files
            .filter { $0.value != "disabled" }
            .keys
            .sorted()
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decodeIfPresent(String.self, forKey: .name) ?? "unknown"
        isEnabled = try container.decodeIfPresent(Bool.self, forKey: .enabled) ?? false
        files = try container.decodeIfPresent([String: String].self, forKey: .files) ?? [:]
    }
}
