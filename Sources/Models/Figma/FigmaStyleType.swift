//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Enumeration of known types of style.
/// Get more info: https://www.figma.com/developers/api#style-type
enum FigmaStyleType: String, Hashable {

    // MARK: - Enumeration Cases

    case fill = "FILL"
    case text = "TEXT"
    case effect = "EFFECT"
    case grid = "GRID"
}
