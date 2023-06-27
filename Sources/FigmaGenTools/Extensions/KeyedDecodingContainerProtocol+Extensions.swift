import Foundation

extension KeyedDecodingContainerProtocol {

    // MARK: - Instance Methods

    public func decode<T: Decodable>(forKey key: Key) throws -> T {
        try decode(T.self, forKey: key)
    }

    public func decodeIfPresent<T: Decodable>(forKey key: Self.Key) throws -> T? {
        try decodeIfPresent(T.self, forKey: key)
    }
}
