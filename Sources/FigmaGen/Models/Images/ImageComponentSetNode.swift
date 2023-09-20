import Foundation

struct ImageComponentSetNode: Encodable, Hashable {

    // MARK: - Instance Properties

    let name: String
    let parentName: String?
    let components: [ImageNode]
    let type: ImageNodeType

    // MARK: - Initializers

    init(name: String, parentName: String?, components: [ImageNode]) {
        self.name = name
        self.parentName = parentName
        self.components = components
        self.type = .componentSet
    }

    init(name: String, parentName: String?, component: ImageNode) {
        self.name = name
        self.parentName = parentName
        self.components = [component]
        self.type = .component
    }
}
