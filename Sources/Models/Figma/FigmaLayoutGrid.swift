//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Guides to align and place objects within a frame.
/// Get more info: https://www.figma.com/developers/api#layoutgrid-type
struct FigmaLayoutGrid: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case rawPattern = "pattern"
        case rawAlignment = "alignment"
        case sectionSize
        case isVisible = "visible"
        case color
        case gutterSize
        case offset
        case count
    }

    // MARK: - Instance Properties

    /// Raw value of orientation of the grid.
    let rawPattern: String

    /// Raw value of alignment of the grid.
    /// Only meaningful for directional grids (columns or rows).
    let rawAlignment: String?

    /// Width of column grid or height of row grid or square grid spacing.
    let sectionSize: Double

    /// Is the grid currently visible?
    /// Defaults to `true`.
    let isVisible: Bool?

    /// Color of the grid.
    let color: FigmaColor

    /// Spacing in between columns and rows.
    /// Relevant only for directional grids (columns or rows).
    let gutterSize: Double?

    /// Spacing before the first column or row.
    /// Relevant only for directional grids (columns or rows).
    let offset: Double?

    /// Number of columns or rows.
    /// Relevant only for directional grids (columns or rows).
    let count: Double?

    /// Orientation of the grid.
    var pattern: FigmaLayoutGridPattern? {
        FigmaLayoutGridPattern(rawValue: rawPattern)
    }

    /// Alignment of the grid.
    /// Relevant only for directional grids (columns or rows).
    var alignment: FigmaLayoutGridAlignment? {
        rawAlignment.flatMap(FigmaLayoutGridAlignment.init)
    }
}
