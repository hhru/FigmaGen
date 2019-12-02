//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Enumeration of known vertical constraints.
/// Get more info: https://www.figma.com/developers/api#layoutconstraint-type
enum FigmaLayoutVerticalConstraint: String, Hashable {

    // MARK: - Enumeration Cases

    /// Node is laid out relative to top of the containing frame.
    case top = "TOP"

    /// Node is laid out relative to bottom of the containing frame.
    case bottom = "BOTTOM"

    /// Node is vertically centered relative to containing frame.
    case center = "CENTER"

    /// Both top and bottom of node are constrained relative to containing frame (node stretches with frame).
    case topBottom = "TOP_BOTTOM"

    /// Node scales vertically with containing frame.
    case scale = "SCALE"
}
