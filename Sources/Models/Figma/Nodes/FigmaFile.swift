//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// File node.
struct FigmaFile: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case name
        case lastModified
        case thumbnailURL = "thumbnailUrl"
        case version
        case schemaVersion
        case document
        case components
        case styles
    }

    // MARK: - Instance Properties

    /// File name.
    let name: String

    /// Last modified date of the file.
    let lastModified: Date

    /// Thumbnail image URL.
    let thumbnailURL: URL

    /// Version of the file.
    let version: String

    /// Version of the file schema.
    let schemaVersion: Int

    /// Document of the file.
    let document: FigmaNode

    /// Components of the file.
    let components: [String: FigmaComponent]?

    /// Styles of the file.
    let styles: [String: FigmaStyle]?
}
