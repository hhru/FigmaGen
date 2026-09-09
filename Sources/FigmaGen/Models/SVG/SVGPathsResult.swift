import Foundation

struct SVGPathsResult {

    let id: String
    let canvas: SVGCanvas?
    let allPaths: [SVGPath]

    init(id: String, canvas: SVGCanvas?, allPaths: [SVGPath]) {
        self.id = id
        self.canvas = canvas
        self.allPaths = allPaths
    }
}
