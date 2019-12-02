//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Enumeration of known styles describing how corners in vector paths are rendered.
/// Get more info: https://www.figma.com/developers/api#vector-props
enum FigmaStrokeJoin: String, Hashable {

    // MARK: - Enumeration Cases

    case miter = "MITER"
    case bevel = "BEVEL"
    case round = "ROUND"
}
