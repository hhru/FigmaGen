import Foundation
import PromiseKit

protocol ImageResourcesProvider {

    // MARK: - Instance Methods

    func saveImages(
        nodes: [ImageComponentSetRenderedNode],
        groupByFrame: Bool,
        format: ImageFormat,
        postProcessor: String?,
        namingStyle: ImageNamingStyle,
        in folderPath: String
    ) -> Promise<[ImageRenderedNode: ImageResource]>
}
