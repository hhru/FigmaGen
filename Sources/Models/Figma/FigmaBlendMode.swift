//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Enumeration describing how layer blends with layers below.
/// Get more info: https://www.figma.com/developers/api#blendmode-type
enum FigmaBlendMode: String, Hashable {

    // MARK: - Enumeration Cases

    case passThrough = "PASS_THROUGH"
    case normal = "NORMAL"

    case darken = "DARKEN"
    case multiply = "MULTIPLY"
    case linearBurn = "LINEAR_BURN"
    case colorBurn = "COLOR_BURN"

    case lighten = "LIGHTEN"
    case screen = "SCREEN"
    case linearDodge = "LINEAR_DODGE"
    case colorDodge = "COLOR_DODGE"

    case overlay = "OVERLAY"
    case softLight = "SOFT_LIGHT"
    case hardLight = "HARD_LIGHT"

    case difference = "DIFFERENCE"
    case exclusion = "EXCLUSION"

    case hue = "HUE"
    case saturation = "SATURATION"
    case color = "COLOR"
    case luminosity = "LUMINOSITY"
}
