import Foundation

struct ImageComponentSetRenderedNode: Encodable, Hashable {

    // MARK: - Instance Properties

    let name: String
    let parentName: String?
    let components: [ImageRenderedNode]
    let type: ImageNodeType
}
