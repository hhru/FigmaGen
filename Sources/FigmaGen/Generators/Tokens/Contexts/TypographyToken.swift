import Foundation

struct TypographyToken {

    // MARK: - Nested Types

    typealias FontSizeToken = ContextToken
    typealias FontScaleToken = ContextToken
    typealias LetterSpacingToken = ContextToken
    typealias LineHeightToken = ContextToken

    // MARK: - Instance Properties

    let path: [String]
    let name: String
    let fontFamily: FontFamilyToken
    let fontWeight: FontWeightToken
    let fontSize: FontSizeToken
    let fontScale: FontScaleToken
    let letterSpacing: LetterSpacingToken
    let lineHeight: LineHeightToken
}
