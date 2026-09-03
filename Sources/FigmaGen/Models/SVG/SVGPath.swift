import Foundation

struct SVGPath {

    let attributes: [String: String]
    let groupIDs: [String]
    let inheritedTransforms: [String]
    let fill: SVGColor?

    init(
        attributes: [String : String],
        groupIDs: [String],
        inheritedTransforms: [String],
        fill: SVGColor?
    ) {
        self.attributes = attributes
        self.groupIDs = groupIDs
        self.inheritedTransforms = inheritedTransforms
        self.fill = fill

        print("id: ", attributes["id"])
    }

    var id: String? {
        attributes["id"]
    }

    var data: String? {
        attributes["d"]
    }

    var fillRule: String? {
        attributes["fill-rule"]
    }

    var isPrimary: Bool {
        id == "primary" || fill == .black
    }

    var isSecondary: Bool {
        id == "secondary" || fill != .black
    }

    var isTertiary: Bool {
        id == "tertiary" || fill != .black
    }

    var isUnknown: Bool {
        fill == nil
    }

    var transform: String? {
        attributes["transform"]
    }

    var allTransforms: [String] {
        inheritedTransforms + [transform].compactMap { $0 }
    }
}
