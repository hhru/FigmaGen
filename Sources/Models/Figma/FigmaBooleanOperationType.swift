//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Enumeration of known types of Boolean operations.
/// Get more info: https://www.figma.com/developers/api#boolean_operation-props
enum FigmaBooleanOperationType: String, Hashable {

    // MARK: - Enumeration Cases

    case union = "UNION"
    case intersect = "INTERSECT"
    case subtract = "SUBTRACT"
    case exclude = "EXCLUDE"
}
