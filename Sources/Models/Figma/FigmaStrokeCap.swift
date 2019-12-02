//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Enumeration of known styles describing the end caps of vector paths.
/// Get more info: https://www.figma.com/developers/api#vector-props
enum FigmaStrokeCap: String, Hashable {

    // MARK: - Enumeration Cases

    case none = "NONE"
    case round = "ROUND"
    case square = "SQUARE"
    case lineArrow = "LINE_ARROW"
    case triangleArrow = "TRIANGLE_ARROW"
}
