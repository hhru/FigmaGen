import Foundation

struct ImageComponentSetRenderedNode: Encodable, Hashable {

    // MARK: - Instance Properties

    let name: String
    let components: [ImageRenderedNode]

    var isSingleComponent: Bool {
        components.count == 1
    }
}
