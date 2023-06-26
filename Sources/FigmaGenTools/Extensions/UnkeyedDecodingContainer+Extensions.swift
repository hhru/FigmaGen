import Foundation

extension UnkeyedDecodingContainer {

    // MARK: - Instance Methods

    public mutating func decode<T: Decodable>() throws -> T {
        try decode(T.self)
    }

    public mutating func decodeIfPresent<T: Decodable>() throws -> T? {
        try decodeIfPresent(T.self)
    }
}
