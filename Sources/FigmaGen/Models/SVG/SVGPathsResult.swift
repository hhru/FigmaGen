import Foundation

struct SVGPathsResult {

    let id: String
    let canvas: SVGCanvas?
    let allPaths: [SVGPath]
    let primaryPaths: [SVGPath]
    let secondaryPaths: [SVGPath]
    let tertiaryPaths: [SVGPath]
    let unknownPaths: [SVGPath]

    init(id: String, canvas: SVGCanvas?, allPaths: [SVGPath]) {
        self.id = id
        self.canvas = canvas
        self.allPaths = allPaths

        primaryPaths = allPaths.filter(\.isPrimary)
        secondaryPaths = allPaths.filter(\.isSecondary)
        tertiaryPaths = allPaths.filter(\.isTertiary)
        unknownPaths = allPaths.filter(\.isUnknown)
    }
}
