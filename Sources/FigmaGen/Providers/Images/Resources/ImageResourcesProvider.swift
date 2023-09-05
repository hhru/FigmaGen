import Foundation
import PromiseKit

protocol ImageResourcesProvider {

    // MARK: - Instance Methods

    func saveImages(
        nodes: [ImageComponentSetRenderedNode],
        parameters: ImagesParameters,
        in folderPath: String
    ) -> Promise<[ImageRenderedNode: ImageResource]>
}
