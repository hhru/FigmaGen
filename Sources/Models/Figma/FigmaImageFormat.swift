//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Enumeration of known image formats.
/// Get more info: https://www.figma.com/developers/api#exportsetting-type
enum FigmaImageFormat: String, Hashable {

    // MARK: - Enumeration Cases

    case jpg = "JPG"
    case png = "PNG"
    case svg = "SVG"
    case pdf = "PDF"
}
