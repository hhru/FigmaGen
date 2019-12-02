//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Layout constraint relative to containing Frame.
/// Get more info: https://www.figma.com/developers/api#layoutconstraint-type
struct FigmaLayoutConstraint: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case rawVertical = "vertical"
        case rawHorizontal = "horizontal"
    }

    // MARK: - Instance Properties

    /// Raw value of vertical constraint.
    let rawVertical: String

    /// Raw value of horizontal constraint.
    let rawHorizontal: String

    /// Vertical constraint.
    var vertical: FigmaLayoutVerticalConstraint? {
        FigmaLayoutVerticalConstraint(rawValue: rawVertical)
    }

    /// Horizontal constraint.
    var horizontal: FigmaLayoutHorizontalConstraint? {
        FigmaLayoutHorizontalConstraint(rawValue: rawHorizontal)
    }
}
