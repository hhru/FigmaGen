import Foundation

// Всё, что нужно SVG-шаблону, чтобы разложить рисунок из Figma в координатах SF Symbols.
struct SVGImageToken {

    let name: String
    let opticalSize: Int
    let designWidth: Double
    let designHeight: Double
    let layers: [SFSymbolLayer]
}
