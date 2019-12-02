//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// A solid color, gradient, or image texture that can be applied as fills or strokes.
/// Get more info: https://www.figma.com/developers/api#paint-type
struct FigmaPaint: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case rawType = "type"
        case isVisible = "visible"
        case opacity
        case color
        case rawBlendMode = "blendMode"
        case gradientHandlePositions
        case gradientStops
        case rawScaleMode = "scaleMode"
        case imageTransform
        case imageRef
        case gifRef
    }

    // MARK: - Instance Properties

    /// Raw type of paint.
    let rawType: String

    /// Is the paint enabled?
    /// Defaults to `true`.
    let isVisible: Bool?

    /// Overall opacity of paint (colors within the paint can also have opacity values which would blend with this).
    /// Defaults to `1`.
    let opacity: Double?

    /// Solid color of the paint.
    /// Relevant only for solid paints.
    let color: FigmaColor?

    /// Raw value of blend mode of the gradient.
    /// Relevant only for gradient paints.
    let rawBlendMode: String?

    /// This field contains three vectors, each of which are a position in normalized object space
    /// (normalized object space is if the top left corner of the bounding box of the object is (0; 0)
    /// and the bottom right is (1; 1)).
    /// The first position corresponds to the start of the gradient
    /// (value 0 for the purposes of calculating gradient stops),
    /// the second position is the end of the gradient (value 1),
    /// and the third handle position determines the width of the gradient.
    /// Relevant only for gradient paints.
    let gradientHandlePositions: [FigmaVector]?

    /// Positions of key points along the gradient axis with the colors anchored there.
    /// Colors along the gradient are interpolated smoothly between neighboring gradient stops.
    /// Relevant only for gradient paints.
    let gradientStops: [FigmaColorStop]?

    /// Raw value of image scaling mode.
    /// Relevant only for image paints.
    let rawScaleMode: String?

    /// Affine transform applied to the image, only present if `scaleMode` is `stretch`.
    /// A 2D affine transformation matrix that can be used to calculate the affine transforms applied to a layer,
    /// including scaling, rotation, shearing, and translation.
    /// The form of the matrix is given as an array of 2 arrays of 3 numbers each.
    /// E.g. the identity matrix would be [[1, 0, 0], [0, 1, 0]].
    /// Relevant only for image paints.
    let imageTransform: [[Double]]?

    /// A reference to an image embedded in this node.
    /// To download the image using this reference, use images route (`FigmaAPIFileImagesRoute`)
    /// to retrieve the mapping from image references to image URLs.
    /// Relevant only for image paints.
    let imageRef: String?

    /// A reference to the GIF embedded in this node, if the image is a GIF.
    /// To download the image using this reference, use images route (`FigmaAPIFileImagesRoute`)
    /// to retrieve the mapping from image references to image URLs.
    /// Relevant only for image paints.
    let gifRef: String?

    /// Type of paint.
    var type: FigmaPaintType? {
        FigmaPaintType(rawValue: rawType)
    }

    /// Blend mode of the gradient.
    /// Relevant only for gradient paints.
    var blendMode: FigmaBlendMode? {
        rawBlendMode.flatMap(FigmaBlendMode.init)
    }

    /// Image scaling mode.
    /// Relevant only for image paints.
    var scaleMode: FigmaScaleMode? {
        rawScaleMode.flatMap(FigmaScaleMode.init)
    }
}
