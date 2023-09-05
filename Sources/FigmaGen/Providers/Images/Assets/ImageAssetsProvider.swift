import Foundation
import PromiseKit

protocol ImageAssetsProvider {

    // MARK: - Instance Methods

    func saveImages(
        nodes: [ImageComponentSetRenderedNode],
        parameters: ImagesParameters,
        in folderPath: String
    ) -> Promise<[ImageComponentSetAsset]>
}
