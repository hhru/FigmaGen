//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

enum TextStylesError: Error {

    // MARK: - Enumeration Cases

    case styleNotFound(nodeName: String, nodeID: String)
    case invalidStyleName(nodeName: String, nodeID: String)

    case textStyleNotFound(nodeName: String, nodeID: String)

    case invalidFontFamily(nodeName: String, nodeID: String)
    case invalidFontName(nodeName: String, nodeID: String)
    case invalidFontWeight(nodeName: String, nodeID: String)
    case invalidFontSize(nodeName: String, nodeID: String)
    case invalidTextColor(nodeName: String, nodeID: String)

    // MARK: - Instance Properties

    var description: String {
        switch self {
        case let .styleNotFound(nodeName, nodeID):
            return #"Figma file does not contain a style for node "\#(nodeName)" (\#(nodeID))"#

        case let .invalidStyleName(nodeName, nodeID):
            return #"Style name of node "\#(nodeName)" (\#(nodeID)) is either empty or nil"#

        case let .textStyleNotFound(nodeName, nodeID):
            return #"Failed to extract a text style of node "\#(nodeName)" (\#(nodeID))"#

        case let .invalidFontFamily(nodeName, nodeID):
            return #"Style font family of node "\#(nodeName)" (\#(nodeID)) is either empty or nil"#

        case let .invalidFontName(nodeName, nodeID):
            return #"Style font name of node "\#(nodeName)" (\#(nodeID)) is either empty or nil"#

        case let .invalidFontWeight(nodeName, nodeID):
            return #"Style font weight of node "\#(nodeName)" (\#(nodeID)) is nil"#

        case let .invalidFontSize(nodeName, nodeID):
            return #"Style font size of node "\#(nodeName)" (\#(nodeID)) is nil"#

        case let .invalidTextColor(nodeName, nodeID):
            return "Text color of node \(nodeName) ('\(nodeID)') cannot be resolved"
        }
    }
}
