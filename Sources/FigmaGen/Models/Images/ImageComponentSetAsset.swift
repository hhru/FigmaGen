import Foundation

struct ImageComponentSetAsset: Encodable, Hashable {

    // MARK: - Instance Properties

    let name: String
    let assets: [ImageRenderedNode: ImageAsset]

    var isSingleComponent: Bool {
        assets.count == 1
    }
}
