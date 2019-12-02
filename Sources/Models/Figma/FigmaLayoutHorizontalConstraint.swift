//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Enumeration of known horizontal constraints.
/// Get more info: https://www.figma.com/developers/api#layoutconstraint-type
enum FigmaLayoutHorizontalConstraint: String, Hashable {

    // MARK: - Enumeration Cases

    /// Node is laid out relative to left of the containing frame.
    case left = "LEFT"

    /// Node is laid out relative to right of the containing frame.
    case right = "RIGHT"

    /// Node is horizontally centered relative to containing frame.
    case center = "CENTER"

    /// Both left and right of node are constrained relative to containing frame (node stretches with frame).
    case leftRight = "LEFT_RIGHT"

    /// Node scales horizontally with containing frame.
    case scale = "SCALE"
}
