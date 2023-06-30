import Foundation

extension SingleValueDecodingContainer {

    // MARK: - Instance Methods

    public func decode<T: Decodable>() throws -> T {
        try decode(T.self)
    }
}
