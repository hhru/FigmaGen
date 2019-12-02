//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// A relative offset within a frame.
/// Get more info: https://www.figma.com/developers/api#frameoffset-type
struct FigmaFrameOffset: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case nodeID = "node_id"
        case nodeOffset = "node_offset"
    }

    // MARK: - Instance Properties

    /// Unique identifier specifying the frame.
    let nodeID: String

    /// 2D vector offset within the frame.
    let nodeOffset: FigmaVector
}
