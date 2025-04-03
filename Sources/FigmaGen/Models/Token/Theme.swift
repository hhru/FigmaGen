import Foundation

struct Theme: Codable, Hashable {

    enum CodingKeys: CodingKey {
        case name
    }

    let name: String

    init(_ name: String) {
        self.name = name
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let name = try? container.decode(String.self) {
            self.name = name
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.name = try container.decode(String.self, forKey: .name)
        }
    }
}

extension Theme {

    static let light = Theme("light")
    static let dark = Theme("dark")
}
