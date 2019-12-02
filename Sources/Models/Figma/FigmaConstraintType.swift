//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Enumeration of known constraint types.
/// Get more info: https://www.figma.com/developers/api#constraint-type
enum FigmaConstraintType: String, Hashable {

    // MARK: - Enumeration Cases

    /// Scale proportionally and set width to value of constraint.
    case width = "WIDTH"

    /// Scale proportionally and set height to value of constraint.
    case height = "HEIGHT"

    /// Scale by value of constraint.
    case scale = "SCALE"
}
