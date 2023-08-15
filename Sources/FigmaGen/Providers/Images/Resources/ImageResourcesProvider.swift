import Foundation
import PromiseKit

protocol ImageResourcesProvider {

    // MARK: - Instance Methods

    func saveImages(
        nodes: [ImageComponentSetRenderedNode],
        groupByFrame: Bool,
        format: ImageFormat,
        postProcessor: String?,
        in folderPath: String
    ) -> Promise<[ImageRenderedNode: ImageResource]>
}
