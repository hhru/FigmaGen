//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Frame node specific proprties.
/// Get more info: https://www.figma.com/developers/api#frame-props
struct FigmaFrameNodeInfo: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case children
        case isLocked = "locked"
        case background
        case exportSettings
        case rawBlendMode = "blendMode"
        case preserveRatio
        case constraints
        case transitionNodeID
        case transitionDuration
        case rawTransitionEasing
        case opacity
        case absoluteBoundingBox
        case clipsContent
        case layoutGrids
        case effects
        case isMask
        case isMaskOutline
    }

    // MARK: - Instance Properties

    /// An array of nodes that are direct children of this node.
    let children: [FigmaNode]?

    /// If true, layer is locked and cannot be edited.
    /// Defaults to `false`.
    let isLocked: Bool?

    /// Background of the node.
    let background: [FigmaPaint]?

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

    /// Whether or not this node clip content outside of its bounds.
    let clipsContent: Bool

    /// An array of layout grids attached to this node.
    /// Group nodes do not have this attribute.
    let layoutGrids: [FigmaLayoutGrid]?

    /// An array of effects attached to this node.
    let effects: [FigmaEffect]?

    /// Does this node mask sibling nodes in front of it?
    /// Defaults to `false`.
    let isMask: Bool?

    /// Does this mask ignore fill style (like gradients) and effects?
    /// Defaults to `false`.
    let isMaskOutline: Bool?

    /// Blend mode.
    /// Describes how this node blends with nodes behind it in the scene.
    var blendMode: FigmaBlendMode? {
        FigmaBlendMode(rawValue: rawBlendMode)
    }

    /// The easing curve used in the prototyping transition on this node.
    var transitionEasing: FigmaEasingType? {
        rawTransitionEasing.flatMap(FigmaEasingType.init)
    }
}
