//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

enum ColorsError: Error, CustomStringConvertible {

    // MARK: - Enumeration Cases

    case styleNotFound(nodeName: String, nodeID: String)
    case invalidStyleName(nodeName: String, nodeID: String)
    case colorNotFound(nodeName: String, nodeID: String)

    // MARK: - Instance Properties

    var description: String {
        switch self {
        case let .styleNotFound(nodeName, nodeID):
            return #"Figma file does not contain a style for node "\#(nodeName)" (\#(nodeID))"#

        case let .invalidStyleName(nodeName, nodeID):
            return #"Style name is either empty or nil in node "\#(nodeName)" (\#(nodeID))"#

        case let .colorNotFound(nodeName, nodeID):
            return #"Failed to extract a color of style in node "\#(nodeName)" (\#(nodeID))"#
        }
    }
}
