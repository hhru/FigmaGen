import Foundation

enum TokenValueType: Hashable {

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
    case unknown

    // MARK: - Instance Properties

    var stringValue: String? {
        switch self {
        case let .a11yScales(value),
             let .borderRadius(value),
             let .color(value),
             let .core(value),
             let .dimension(value),
             let .fontFamilies(value),
             let .fontSizes(value),
             let .fontWeights(value),
             let .letterSpacing(value),
             let .lineHeights(value),
             let .opacity(value),
             let .paragraphSpacing(value),
             let .scaling(value),
             let .sizing(value),
             let .spacing(value),
             let .textCase(value),
             let .textDecoration(value):
            return value

        case .animation, .boxShadow, .typography, .unknown:
            return nil
        }
    }
}
