//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Enumeration of known orientations of grid.
/// Get more info: https://www.figma.com/developers/api#layoutgrid-type
enum FigmaLayoutGridPattern: String, Hashable {

    // MARK: - Enumeration Cases

    /// Vertical grid.
    case columns = "COLUMNS"

    /// Horizontal grid.
    case rows = "ROWS"

    /// Square grid.
    case grid = "GRID"
}
