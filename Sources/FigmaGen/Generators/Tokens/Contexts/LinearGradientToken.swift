import Foundation

struct LinearGradientToken: TokenProtocol, Encodable {

    struct ColorStop: Encodable {
        let color: String
        let percentage: CGFloat
    }

    // Нужен, т.к CGPoint нельзя использовать корректно в stencil шаблоне
    struct Point: Encodable {
        let x: CGFloat
        let y: CGFloat
    }

    struct GradientThemeValue: Encodable {
        let stops: [ColorStop]
        let startPoint: Point
        let endPoint: Point
    }

    let path: [String]
    let name: String

    let themedValue: [Theme: GradientThemeValue]
}
