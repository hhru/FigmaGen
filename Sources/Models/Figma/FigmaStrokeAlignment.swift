//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Enumeration of known types of stroke alignment.
/// Get more info: https://www.figma.com/developers/api#vector-props
enum FigmaStrokeAlignment: String, Hashable {

    // MARK: - Enumeration Cases

    /// Draw stroke inside the shape boundary.
    case inside = "INSIDE"

    /// Draw stroke outside the shape boundary.
    case outside = "OUTSIDE"

    /// Draw stroke centered along the shape boundary.
    case center = "CENTER"
}
