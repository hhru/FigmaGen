//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

enum NodesError: Error, CustomStringConvertible {

    // MARK: - Enumeration Cases

    case invalidNodeID(_ nodeID: String)

    // MARK: - Instance Properties

    var description: String {
        switch self {
        case let .invalidNodeID(nodeID):
            return "Figma node ID '\(nodeID)' is invalid"
        }
    }
}
