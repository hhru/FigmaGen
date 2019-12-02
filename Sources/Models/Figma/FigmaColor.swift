//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// An RGBA color.
/// Get more info: https://www.figma.com/developers/api#color-type
struct FigmaColor: Decodable, Hashable {

    // MARK: - Instance Properties

    /// Red channel value, between 0 and 1.
    let r: Double

    /// Green channel value, between 0 and 1.
    let g: Double

    /// Blue channel value, between 0 and 1.
    let b: Double

    /// Alpha channel value, between 0 and 1.
    let a: Double
}
