import Foundation

struct Theme: Codable, Hashable {

    enum CodingKeys: CodingKey {
        case key
    }

    let key: String

    init(_ key: String) {
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
}

extension Theme {
    static let light = Theme("light")
    static let dark = Theme("dark")
}
