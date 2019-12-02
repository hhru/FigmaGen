//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// A set of properties that can be applied to nodes and published.
/// Styles for a property can be created in the corresponding property's panel while editing a file.
/// Get more info: https://www.figma.com/developers/api#style-type
struct FigmaStyle: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case key
        case rawType = "styleType"
        case name
        case description
    }

    // MARK: - Instance Properties

    /// The key of the style.
    let key: String?

    /// Raw type of the style
    let rawType: String

    /// The name of the style.
    let name: String?

    /// The description of the style.
    let description: String?

    /// Type of the style.
    var type: FigmaStyleType? {
        FigmaStyleType(rawValue: rawType)
    }
}
