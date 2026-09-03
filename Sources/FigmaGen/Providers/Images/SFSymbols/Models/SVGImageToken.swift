import Foundation

// Everything the SVG template needs to lay a Figma drawing out in SF Symbols coordinates.
struct SVGImageToken {

    let name: String
    let opticalSize: Int
    let designWidth: Double
    let designHeight: Double
    let layers: [SFSymbolLayer]
}
