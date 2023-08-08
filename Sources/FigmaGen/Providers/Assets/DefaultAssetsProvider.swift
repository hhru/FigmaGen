import Foundation
import FigmaGenTools
import PromiseKit
import PathKit

final class DefaultAssetsProvider: AssetsProvider {

    // MARK: - Instance Methods

    private func saveAssetFolder(_ folder: AssetFolder, in folderPath: Path) throws {
        try folder.save(in: folderPath.string)
    }

    // MARK: -

    func saveAssetFolder(_ folder: AssetFolder, in folderPath: String) -> Promise<Void> {
        perform(on: DispatchQueue.global(qos: .userInitiated)) {
            try self.saveAssetFolder(folder, in: Path(folderPath))
        }
    }
}

extension String {

    // MARK: - Type Properties

    fileprivate static let assetsExtension = "xcassets"
}
