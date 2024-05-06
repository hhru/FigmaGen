import Foundation

struct AnyKey: CodingKey {

    enum Errors: Error {
        case invalidKeyName
    }

    var stringValue: String
    var intValue: Int?

    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = Int(stringValue)
    }

    init?(intValue: Int) {
        self.intValue = intValue
        stringValue = "\(intValue)"
    }

    static func key(named name: String) throws -> Self {
        guard let key = Self(stringValue: name) else {
            throw Errors.invalidKeyName
        }
        return key
    }
}
