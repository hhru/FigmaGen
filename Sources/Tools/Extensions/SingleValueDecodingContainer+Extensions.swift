//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

extension SingleValueDecodingContainer {

    // MARK: - Instance Methods

    func decode<T: Decodable>() throws -> T {
        return try decode(T.self)
    }
}
