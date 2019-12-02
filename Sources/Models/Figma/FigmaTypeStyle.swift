//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Metadata for character formatting.
/// Get more info: https://www.figma.com/developers/api#typestyle-type
struct FigmaTypeStyle: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case fontFamily
        case fontPostScriptName
        case fontWeight
        case fontSize
        case isItalic = "italic"
        case paragraphSpacing
        case paragraphIndent
        case rawTextCase = "textCase"
        case rawTextDecoration = "textDecoration"
        case rawTextHorizontalAlignment = "textAlignHorizontal"
        case rawTextVerticalAlignment = "textAlignVertical"
        case letterSpacing
        case fills
        case lineHeight = "lineHeightPx"
        case lineHeightPercentFontSize = "lineHeightPercentFontSize"
        case rawLineHeightUnit = "lineHeightUnit"
    }

    // MARK: - Instance Properties

    /// Font family of text (standard name).
    let fontFamily: String?

    /// PostScript font name.
    let fontPostScriptName: String?

    /// Numeric font weight.
    let fontWeight: Double?

    /// Font size in px.
    let fontSize: Double?

    /// Whether or not text is italicized?
    /// Defaults to `false`.
    let isItalic: Bool?

    /// Space between paragraphs in px.
    /// Defaults to `0`.
    let paragraphSpacing: Double?

    /// Paragraph indentation in px.
    /// Defaults to `0`.
    let paragraphIndent: Double?

    /// Raw value of text casing applied to the node.
    /// Defaults to `ORIGINAL`.
    let rawTextCase: String?

    /// Raw value of text decoration applied to the node.
    /// Defaults to `NONE`.
    let rawTextDecoration: String?

    /// Raw value of horizontal text alignment.
    let rawTextHorizontalAlignment: String?

    /// Raw value of vertical text alignment.
    let rawTextVerticalAlignment: String?

    /// Space between characters in px.
    let letterSpacing: Double?

    /// Paints applied to characters.
    let fills: [FigmaPaint]?

    /// Line height in px.
    let lineHeight: Double?

    /// Line height as a percentage of the font size.
    /// Defaults to `100`.
    let lineHeightPercentFontSize: Double?

    /// Raw value of unit type of the line height value specified by the user.
    let rawLineHeightUnit: String?

    /// Text casing applied to the node.
    var textCase: FigmaTextCase? {
        guard let rawTextCase = rawTextCase else {
            return .original
        }

        return FigmaTextCase(rawValue: rawTextCase)
    }

    /// Text decoration applied to the node.
    var textDecoration: FigmaTextDecoration? {
        guard let rawTextDecoration = rawTextDecoration else {
            return FigmaTextDecoration.none
        }

        return FigmaTextDecoration(rawValue: rawTextDecoration)
    }

    /// Horizontal text alignment.
    var textHorizontalAlignment: FigmaTextHorizontalAlignment? {
        rawTextHorizontalAlignment.flatMap(FigmaTextHorizontalAlignment.init)
    }

    /// Vertical text alignment.
    var textVericalAlignment: FigmaTextVerticalAlignment? {
        rawTextVerticalAlignment.flatMap(FigmaTextVerticalAlignment.init)
    }

    /// The unit of the line height value specified by the user.
    var lineHeightUnit: FigmaLineHeightUnit? {
        rawLineHeightUnit.flatMap(FigmaLineHeightUnit.init)
    }
}
