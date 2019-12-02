//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Enumeration describing animation easing curves.
/// Get more info: https://www.figma.com/developers/api#easingtype-type
enum FigmaEasingType: String, Hashable {

    // MARK: - Enumeration Cases

    /// Ease in with an animation curve similar to CSS ease-in.
    case easeIn = "EASE_IN"

    /// Ease out with an animation curve similar to CSS ease-out.
    case easeOut = "EASE_OUT"

    /// Ease in and then out with an animation curve similar to CSS ease-in-out.
    case easeInOut = "EASE_IN_AND_OUT"
}
