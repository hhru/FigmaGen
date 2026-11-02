import Foundation

/// Манифест токенов плагина SXL Studio (`tokens/config.json`).
///
/// Описывает коллекции токенов, их режимы (modes) и файлы, из которых состоит каждый режим.
struct SXLTokensManifest: Decodable, Hashable {

    private enum CodingKeys: String, CodingKey {
        case schema = "$schema"
        case collections
    }

    // MARK: - Type Properties

    static let schema = "sxl-studio/config"

    // MARK: - Instance Properties

    let schema: String?
    let collections: [SXLTokensCollection]

    // MARK: - Initializers

    init(schema: String?, collections: [SXLTokensCollection]) {
        self.schema = schema
        self.collections = collections
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        schema = try? container.decodeIfPresent(String.self, forKey: .schema)
        collections = (try? container.decodeIfPresent([SXLTokensCollection].self, forKey: .collections)) ?? []
    }

    // MARK: - Instance Methods

    func collection(named name: String) -> SXLTokensCollection? {
        collections.first { $0.name == name }
    }
}
