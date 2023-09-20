import Foundation

struct ImageComponentSetAsset: Encodable, Hashable {

    // MARK: - Instance Properties

    let name: String
    let parentName: String?
    let assets: [ImageRenderedNode: ImageAsset]
    let nodeType: ImageNodeType
}
