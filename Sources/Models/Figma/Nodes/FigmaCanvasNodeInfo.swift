//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Canvas node specific proprties.
/// Get more info: https://www.figma.com/developers/api#canvas-props
struct FigmaCanvasNodeInfo: Decodable, Hashable {

    // MARK: - Instance Properties

    /// An array of top level layers on the canvas.
    let children: [FigmaNode]

    /// Background color of the canvas.
    let backgroundColor: FigmaColor

    /// Node ID that corresponds to the start frame for prototypes.
    let prototypeStartNodeID: String?

    /// An array of export settings representing images to export from the canvas.
    let exportSettings: [FigmaExportSetting]?
}
