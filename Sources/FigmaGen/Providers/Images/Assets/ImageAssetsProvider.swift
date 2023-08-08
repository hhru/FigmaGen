import Foundation
import PromiseKit

protocol ImageAssetsProvider {

    // MARK: - Instance Methods

    func saveImages(
        nodes: [ImageComponentSetRenderedNode],
        format: ImageFormat,
        preserveVectorData: Bool,
        in folderPath: String
    ) -> Promise<[ImageComponentSetAsset]>
}
