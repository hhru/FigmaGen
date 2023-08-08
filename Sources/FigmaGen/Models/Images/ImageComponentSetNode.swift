import Foundation

struct ImageComponentSetNode: Encodable, Hashable {

    // MARK: - Instance Properties

    let name: String
    let components: [ImageNode]

    // MARK: - Initializers

    init(name: String, components: [ImageNode]) {
        self.name = name
        self.components = components
    }

    init(name: String, component: ImageNode) {
        self.name = name
        self.components = [component]
    }
}
