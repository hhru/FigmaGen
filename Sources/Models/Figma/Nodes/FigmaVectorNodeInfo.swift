//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Vector node specific proprties.
/// Get more info: https://www.figma.com/developers/api#vector-props
struct FigmaVectorNodeInfo: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case isLocked = "locked"
        case exportSettings
        case rawBlendMode = "blendMode"
        case preserveRatio
        case constraints
        case transitionNodeID
        case transitionDuration
        case rawTransitionEasing
        case opacity
        case absoluteBoundingBox
        case effects
        case isMask
        case fills
        case strokes
        case strokeWeight
        case rawStrokeCap = "strokeCap"
        case rawStrokeJoin = "strokeJoin"
        case strokeDashes
        case strokeMiterAngle
        case rawStrokeAlignment = "strokeAlign"
        case styles
    }

    // MARK: - Instance Properties

    /// If true, layer is locked and cannot be edited.
    /// Defaults to `false`.
    let isLocked: Bool?

    /// An array of export settings representing images to export from node.
    let exportSettings: [FigmaExportSetting]?

    /// Raw value of blend mode.
    /// Describes how this node blends with nodes behind it in the scene.
    let rawBlendMode: String

    /// Keep height and width constrained to same ratio.
    /// Defaults to `false`.
    let preserveRatio: Bool?

    /// Horizontal and vertical layout constraints for node.
    let constraints: FigmaLayoutConstraint

    /// Node ID of node to transition to in prototyping.
    let transitionNodeID: String?

    /// The duration of the prototyping transition on this node in milliseconds.
    let transitionDuration: Double?

    /// Raw value of easing curve type used in the prototyping transition on this node.
    let rawTransitionEasing: String?

    /// Opacity of the node.
    /// Defaults to `1`.
    let opacity: Double?

    /// Bounding box of the node in absolute space coordinates.
    let absoluteBoundingBox: FigmaRectangle

    /// An array of effects attached to this node.
    let effects: [FigmaEffect]?

    /// Does this node mask sibling nodes in front of it?
    /// Defaults to `false`.
    let isMask: Bool?

    /// An array of fill paints applied to the node.
    let fills: [FigmaPaint]?

    /// An array of stroke paints applied to the node.
    let strokes: [FigmaPaint]?

    /// The weight of strokes on the node.
    let strokeWeight: Double

    /// Raw value of style that describes the end caps of vector paths.
    /// Defaults to `NONE`.
    let rawStrokeCap: String?

    /// Raw value of style that describes how corners in vector paths are rendered.
    /// Defaults to `MITER`.
    let rawStrokeJoin: String?

    /// An array of floating point numbers describing the pattern of dash length
    /// and gap lengths that the vector path follows.
    /// For example a value of [1, 2] indicates
    /// that the path has a dash of length 1 followed by a gap of length 2, repeated.
    let strokeDashes: [Double]?

    /// The corner angle, in degrees, below which `strokeJoin` will be set to `bevel` to avoid super sharp corners.
    /// Only valid if `strokeJoin` is `miter`.
    /// Defaults to `28.96`.
    let strokeMiterAngle: Double?

    /// Raw value of stroke alignment that describes where stroke is drawn relative to the vector outline.
    let rawStrokeAlignment: String

    /// A mapping of a raw style type to style ID (see `FigmaStyle`) of styles present on this node.
    /// The style ID can be used to look up more information about the style in the top-level styles field.
    let styles: [String: String]?

    /// Blend mode.
    /// Describes how this node blends with nodes behind it in the scene.
    var blendMode: FigmaBlendMode? {
        FigmaBlendMode(rawValue: rawBlendMode)
    }

    /// The easing curve used in the prototyping transition on this node.
    var transitionEasing: FigmaEasingType? {
        rawTransitionEasing.flatMap(FigmaEasingType.init)
    }

    /// Style that describes the end caps of vector paths.
    var strokeCap: FigmaStrokeCap? {
        guard let rawStrokeCap = rawStrokeCap else {
            return FigmaStrokeCap.none
        }

        return FigmaStrokeCap(rawValue: rawStrokeCap)
    }

    /// Style that describes how corners in vector paths are rendered.
    var strokeJoin: FigmaStrokeJoin? {
        guard let rawStrokeJoin = rawStrokeJoin else {
            return FigmaStrokeJoin.miter
        }

        return FigmaStrokeJoin(rawValue: rawStrokeJoin)
    }

    /// Stroke alignment that describes where stroke is drawn relative to the vector outline.
    var strokeAlignment: FigmaStrokeAlignment? {
        FigmaStrokeAlignment(rawValue: rawStrokeAlignment)
    }

    // MARK: - Instance Methods

    func styleID(of styleType: FigmaStyleType) -> String? {
        return styles?[styleType.rawValue.lowercased()]
    }
}
