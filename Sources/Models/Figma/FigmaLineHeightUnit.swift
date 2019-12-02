//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Enumeration of known line height units.
/// Get more info: https://www.figma.com/developers/api#typestyle-type
enum FigmaLineHeightUnit: String, Hashable {

    // MARK: - Enumeration Cases

    case pixels = "PIXELS"
    case fontSizePercent = "FONT_SIZE_%"
    case intrinsicPercent = "INTRINSIC_%"
}
