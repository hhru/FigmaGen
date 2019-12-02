//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Slice node specific proprties.
/// Get more info: https://www.figma.com/developers/api#slice-props
struct FigmaSliceNodeInfo: Decodable, Hashable {

    // MARK: - Instance Properties

    /// An array of export settings representing images to export from this node.
    let exportSettings: [FigmaExportSetting]?

    /// Bounding box of the node in absolute space coordinates.
    let absoluteBoundingBox: FigmaRectangle
}
