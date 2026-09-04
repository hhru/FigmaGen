import Foundation

struct SVGPath {

    // MARK: - Instance Properties

    let id: String?
    let data: String?
    let fillRule: String?
    let fill: SVGColor?
    let transform: String?
    let groupIDs: [String]
    let groupTransforms: [String]

    var idChain: String {
        (groupIDs + [id].compactMap { $0 }).joined(separator: ";")
    }

    var transformChain: [String] {
        groupTransforms + [transform].compactMap { $0 }
    }
}
