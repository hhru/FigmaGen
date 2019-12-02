//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

enum ConfigurationError: Error, CustomStringConvertible {

    // MARK: - Enumeration Cases

    case invalidFileKey
    case invalidAccessToken

    // MARK: - Instance Properties

    var description: String {
        switch self {
        case .invalidFileKey:
            return "Figma file key is either empty or nil"

        case .invalidAccessToken:
            return "Figma access token is either empty or nil"
        }
    }
}
