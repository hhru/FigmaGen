import Foundation

enum TokenValueType: Codable, Hashable {

    // MARK: - Enumeration Cases

    case a11yScales(value: String)
    case animation(value: TokenAnimationValue)
    case borderRadius(value: String)
    case boxShadow(value: TokenBoxShadowValue)
    case color(value: String)
    case core(value: String)
    case dimension(value: String)
    case fontFamilies(value: String)
    case fontSizes(value: String)
    case fontWeights(value: String)
    case letterSpacing(value: String)
    case lineHeights(value: String)
    case opacity(value: String)
    case paragraphSpacing(value: String)
    case scaling(value: String)
    case sizing(value: String)
    case spacing(value: String)
    case textCase(value: String)
    case textDecoration(value: String)
    case typography(value: TokenTypographyValue)
}
