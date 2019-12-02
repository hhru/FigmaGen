//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Enumeration of known scale modes.
/// Get more info: https://www.figma.com/developers/api#paint-type
enum FigmaScaleMode: String, Hashable {

    // MARK: - Enumeration Cases

    case fill = "FILL"
    case fit = "FIT"
    case tile = "TILE"
    case stretch = "STRETCH"
}
