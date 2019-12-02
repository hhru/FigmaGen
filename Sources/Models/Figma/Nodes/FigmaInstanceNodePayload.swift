//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Instance node specific proprties.
/// Get more info: https://www.figma.com/developers/api#instance-props
struct FigmaInstanceNodePayload: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case componentID = "componentId"
    }

    // MARK: - Instance Properties

    /// Identifier of component that this instance came from, refers to `components` table.
    let componentID: String
}
