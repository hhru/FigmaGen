//
// FigmaGen
// Copyright © 2020 HeadHunter
// MIT Licence
//

import Foundation

enum SpacingsError: Error, CustomStringConvertible {

   // MARK: - Enumeration Cases

    case invalidSpacingName(nodeName: String, nodeID: String)
    case spacingNotFound(nodeName: String, nodeID: String)
    
    // MARK: - Instance Properties

    var description: String {
        switch self {
        case let .invalidSpacingName(nodeName, nodeID):
            return #"Spacing name is empty in node "\#(nodeName)" (\#(nodeID))"#

        case let .spacingNotFound(nodeName, nodeID):
            return #"Failed to extract a spacing from in node "\#(nodeName)" (\#(nodeID))"#
        }
    }
}
