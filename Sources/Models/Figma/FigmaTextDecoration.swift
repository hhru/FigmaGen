//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Enumeration of known type of text decoration.
/// Get more info: https://www.figma.com/developers/api#typestyle-type
enum FigmaTextDecoration: String, Hashable {

    // MARK: - Enumeration Cases

    case none = "NONE"
    case strikethrough = "STRIKETHROUGH"
    case underline = "UNDERLINE"
}
