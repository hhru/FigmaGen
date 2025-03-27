import Foundation

struct LinearGradientToken: TokenProtocol, Encodable {

    struct ColorStop: Encodable {
        let color: String
        let percentage: CGFloat
    }

    struct GradientThemeValue: Encodable {
        let stops: [ColorStop]
        let startPoint: CGPoint
        let endPoint: CGPoint
    }

    let path: [String]
    let name: String

    let dayTheme: GradientThemeValue
    let nightTheme: GradientThemeValue
    let zpDayTheme: GradientThemeValue
}
