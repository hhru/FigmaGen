import Foundation

// Size of the root `<svg>` element, which Figma exports equal to the component box.
// SF Symbols geometry is built from this box and not from the visible path bounds,
// so that the padding designed in Figma is preserved.
struct SVGCanvas: Equatable {

    let width: Double
    let height: Double
}
