//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Sizing constraint for exports.
/// Get more info: https://www.figma.com/developers/api#constraint-type
struct FigmaConstraint: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case rawType = "type"
        case value
    }

    // MARK: - Instance Properties

    /// Raw type of constraint to apply.
    let rawType: String

    /// Value of constraint to apply.
    let value: Double

    /// Type of constraint to apply.
    var type: FigmaConstraintType? {
        FigmaConstraintType(rawValue: rawType)
    }
}
