//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

extension UnkeyedDecodingContainer {

    // MARK: - Instance Methods

    mutating func decode<T: Decodable>() throws -> T {
        return try decode(T.self)
    }

    mutating func decodeIfPresent<T: Decodable>() throws -> T? {
        return try decodeIfPresent(T.self)
    }
}
