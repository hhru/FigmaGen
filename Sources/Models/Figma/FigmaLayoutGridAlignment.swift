//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Enumeration of known alignment types of grid.
/// Get more info: https://www.figma.com/developers/api#layoutgrid-type
enum FigmaLayoutGridAlignment: String, Hashable {

    // MARK: - Enumeration Cases

    /// Grid starts at the left or top of the frame.
    case min = "MIN"

    /// Grid is stretched to fit the frame.
    case stretch = "STRETCH"

    /// Grid is center aligned.
    case center = "CENTER"
}
