//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Text node specific proprties.
/// Get more info: https://www.figma.com/developers/api#rectangle-props
struct FigmaTextNodePayload: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case text = "characters"
        case style
        case characterStyleOverrides
        case styleOverrideTable
    }

    // MARK: - Instance Properties

    /// Text contained within text box.
    let text: String

    /// Style of text including font family and weight.
    let style: FigmaTypeStyle?

    /// Array with same number of elements as characeters in text box,
    /// each element is a reference to the `styleOverrideTable`
    /// and maps to the corresponding character in the `text` field.
    /// Elements with value 0 have the default type style.
    let characterStyleOverrides: [Int]?

    /// Map from ID to `FigmaTypeStyle` for looking up style overrides.
    let styleOverrideTable: [Int: FigmaTypeStyle]?
}
