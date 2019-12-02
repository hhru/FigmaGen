//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// A visual effect such as a shadow or blur.
/// Get more info: https://www.figma.com/developers/api#effect-type
struct FigmaEffect: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case rawType = "type"
        case isVisible = "visible"
        case radius
        case color
        case rawBlendMode = "blendMode"
        case offset
    }

    // MARK: - Instance Properties

    /// Raw type of effect.
    let rawType: String

    /// Is the effect active?
    /// Defaults to `true`.
    let isVisible: Bool?

    /// Radius of the blur effect (applies to shadows as well)
    let radius: Double

    /// The color of the shadow.
    /// Relevant only for shadows.
    let color: FigmaColor?

    /// Raw value of blend mode of the shadow.
    /// Relevant only for shadows.
    let rawBlendMode: String?

    /// How far the shadow is projected in the x and y directions.
    /// Relevant only for shadows.
    let offset: FigmaVector?

    /// Type of effect.
    var type: FigmaEffectType? {
        FigmaEffectType(rawValue: rawType)
    }

    /// Blend mode of the shadow.
    /// Relevant only for shadows.
    var blendMode: FigmaBlendMode? {
        rawBlendMode.flatMap(FigmaBlendMode.init)
    }
}
