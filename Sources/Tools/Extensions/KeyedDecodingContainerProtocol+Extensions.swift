//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

extension KeyedDecodingContainerProtocol {

    // MARK: - Instance Methods

    func decode<T: Decodable>(forKey key: Key) throws -> T {
        return try decode(T.self, forKey: key)
    }

    func decodeIfPresent<T: Decodable>(forKey key: Self.Key) throws -> T? {
        return try decodeIfPresent(T.self, forKey: key)
    }
}
