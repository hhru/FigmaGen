import Foundation

struct Theme: Codable, Hashable {

    enum CodingKeys: CodingKey {
        case key
    }

    let key: String

    init(key: String) {
        self.key = key
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let key = try? container.decode(String.self) {
            self.key = key
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.key = try container.decode(String.self, forKey: .key)
        }
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        return try container.encode(key)
    }
}

extension Theme {
    static let light = Theme(key: "light")
    static let dark = Theme(key: "dark")
}
