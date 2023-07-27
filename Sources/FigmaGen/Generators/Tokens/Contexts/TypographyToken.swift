import Foundation

struct TypographyToken {

    // MARK: - Nested Types

    typealias FontSizeToken = ContextToken
    typealias FontScaleToken = ContextToken
    typealias LetterSpacingToken = ContextToken
    typealias LineHeightToken = ContextToken
    typealias TextDecorationToken = ContextToken
    typealias ParagraphSpacingToken = ContextToken
    typealias ParagraphIndentToken = ContextToken

    // MARK: - Instance Properties

    let path: [String]
    let name: String
    let fontFamily: FontFamilyToken
    let fontWeight: FontWeightToken
    let lineHeight: LineHeightToken
    let fontSize: FontSizeToken
    let letterSpacing: LetterSpacingToken?
    let paragraphSpacing: ParagraphSpacingToken
    let paragraphIndent: ParagraphIndentToken?
    let textDecoration: TextDecorationToken?
    let fontScale: FontScaleToken?
}
