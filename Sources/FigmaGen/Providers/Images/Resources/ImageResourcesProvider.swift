import Foundation
import PromiseKit

protocol ImageResourcesProvider {

    // MARK: - Instance Methods

    func saveImages(
        nodes: [ImageComponentSetRenderedNode],
        groupByFrame: Bool,
        format: ImageFormat,
        in folderPath: String
    ) -> Promise<[ImageRenderedNode: ImageResource]>
}
