//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Format and size to export an asset at.
/// Get more info: https://www.figma.com/developers/api#exportsetting-type
struct FigmaExportSetting: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case suffix
        case rawFormat = "format"
        case constraint
    }

    // MARK: - Instance Properties

    /// File suffix to append to all filenames.
    let suffix: String

    /// Raw value of the image format.
    let rawFormat: String

    /// Constraint that determines sizing of exported asset.
    let constraint: FigmaConstraint

    /// Image format.
    var format: FigmaImageFormat? {
        FigmaImageFormat(rawValue: rawFormat)
    }
}
