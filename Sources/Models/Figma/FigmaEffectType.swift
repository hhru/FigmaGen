//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Enumeration of known effect types.
/// Get more info: https://www.figma.com/developers/api#effect-type
enum FigmaEffectType: String, Hashable {

    // MARK: - Enumeration Cases

    case innerShadow = "INNER_SHADOW"
    case dropShadow = "DROP_SHADOW"
    case layerBlur = "LAYER_BLUR"
    case backgroundBlur = "BACKGROUND_BLUR"
}
