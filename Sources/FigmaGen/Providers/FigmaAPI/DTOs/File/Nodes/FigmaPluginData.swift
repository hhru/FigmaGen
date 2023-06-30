import Foundation
import FigmaGenTools

enum FigmaPluginData: Decodable, Hashable {

    // MARK: - Enumeration Cases

    case string(String)
    case dictionary([String: AnyCodable])

    // MARK: - Initializers

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else if let dictionaryValue = try? container.decode([String: AnyCodable].self) {
            self = .dictionary(dictionaryValue)
        } else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "plugin data is not a string or dictionary"
            )
        }
    }
}
