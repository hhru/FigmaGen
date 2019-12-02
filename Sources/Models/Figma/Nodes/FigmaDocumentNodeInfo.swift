//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Document node specific proprties.
/// Get more info: https://www.figma.com/developers/api#document-props
struct FigmaDocumentNodeInfo: Decodable, Hashable {

    // MARK: - Instance Properties

    /// An array of canvases attached to the document.
    let children: [FigmaNode]?
}
