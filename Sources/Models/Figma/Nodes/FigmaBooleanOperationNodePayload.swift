//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Boolean operation node specific proprties.
/// Get more info: https://www.figma.com/developers/api#boolean_operation-props
struct FigmaBooleanOperationNodePayload: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case children
        case rawOperationType = "booleanOperation"
    }

    // MARK: - Instance Properties

    /// An array of nodes that are being boolean operated on.
    let children: [FigmaNode]?

    /// Raw type of Boolean operation.
    let rawOperationType: String

    /// Type of Boolean operation.
    var operationType: FigmaBooleanOperationType? {
        FigmaBooleanOperationType(rawValue: rawOperationType)
    }
}
