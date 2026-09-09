import Foundation

struct SVGPath {

    let attributes: [String: String]
    let groupIDs: [String]
    let inheritedTransforms: [String]
    let fill: SVGColor?

    var id: String? {
        attributes["id"]
    }
    
    var wholeID: String {
        (groupIDs + [attributes["id"]].compactMap { $0 })
            .joined(separator: ";")
    }

    var data: String? {
        attributes["d"]
    }

    var fillRule: String? {
        attributes["fill-rule"]
    }

    var allTransforms: [String] {
        inheritedTransforms + [attributes["transform"]].compactMap { $0 }
    }

    // MARK: - Initializers

    init(
        attributes: [String: String],
        groupIDs: [String],
        inheritedTransforms: [String],
        fill: SVGColor?
    ) {
        self.attributes = attributes
        self.groupIDs = groupIDs
        self.inheritedTransforms = inheritedTransforms
        self.fill = fill
    }
}
