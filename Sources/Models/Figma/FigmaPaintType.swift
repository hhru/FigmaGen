//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Enumeration of known paint types.
/// Get more info: https://www.figma.com/developers/api#paint-type
enum FigmaPaintType: String, Hashable {

    // MARK: - Enumeration Cases

    case solid = "SOLID"

    case gradientLinear = "GRADIENT_LINEAR"
    case gradientRadial = "GRADIENT_RADIAL"
    case gradientAngular = "GRADIENT_ANGULAR"
    case gradientDiamond = "GRADIENT_DIAMOND"

    case image = "IMAGE"
    case emoji = "EMOJI"
}
