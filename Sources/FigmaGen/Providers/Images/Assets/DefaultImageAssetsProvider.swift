import Foundation
import FigmaGenTools
import PromiseKit
import PathKit

final class DefaultImageAssetsProvider: ImageAssetsProvider, ImagesFolderPathResolving {

    // MARK: - Instance Properties

    let assetsProvider: AssetsProvider
    let dataProvider: DataProvider

    // MARK: - Initializers

    init(assetsProvider: AssetsProvider, dataProvider: DataProvider) {
        self.assetsProvider = assetsProvider
        self.dataProvider = dataProvider
    }

    // MARK: - Instance Methods

    private func resolveName(
        for node: ImageRenderedNode,
        setNode: ImageComponentSetRenderedNode,
        namingStyle: ImageNamingStyle
    ) -> String {
        let name = setNode.isSingleComponent ? node.base.name : "\(setNode.name) \(node.base.name)"

        switch namingStyle {
        case .camelCase:
            return name.camelized

        case .snakeCase:
            return name.snakeCased
        }
    }

    private func makeAsset(
        for node: ImageRenderedNode,
        setNode: ImageComponentSetRenderedNode,
        format: ImageFormat,
        preserveVectorData: Bool,
        groupByFrame: Bool,
        namingStyle: ImageNamingStyle,
        folderPath: Path
    ) -> ImageAsset {
        let name = resolveName(for: node, setNode: setNode, namingStyle: namingStyle)
        let folderPath = resolveFolderPath(groupByFrame: groupByFrame, setNode: setNode, folderPath: folderPath)

        let filePaths = node.urls.keys.reduce(into: [:]) { result, scale in
            result[scale] = folderPath
                .appending(fileName: name, extension: AssetImageSet.pathExtension)
                .appending(fileName: name.appending(scale.fileNameSuffix), extension: format.fileExtension)
                .string
        }

        return ImageAsset(name: name, filePaths: filePaths, preserveVectorData: preserveVectorData)
    }

    private func makeAssets(
        for nodes: [ImageComponentSetRenderedNode],
        format: ImageFormat,
        preserveVectorData: Bool,
        groupByFrame: Bool,
        namingStyle: ImageNamingStyle,
        folderPath: Path
    ) -> [ImageComponentSetAsset] {
        nodes.map { setNode in
            var assets: [ImageRenderedNode: ImageAsset] = [:]

            setNode.components.forEach { node in
                assets[node] = makeAsset(
                    for: node,
                    setNode: setNode,
                    format: format,
                    preserveVectorData: preserveVectorData,
                    groupByFrame: groupByFrame,
                    namingStyle: namingStyle,
                    folderPath: folderPath
                )
            }

            return ImageComponentSetAsset(
                name: setNode.name,
                parentName: setNode.parentName,
                assets: assets
            )
        }
    }

    private func makeAssetImageSet(for asset: ImageAsset) -> AssetImageSet {
        let assetImages = asset.filePaths.map { scale, filePath in
            AssetImage(fileName: Path(filePath).lastComponent, scale: scale.assetImageScale)
        }
        let contents = AssetImageSetContents(
            info: .defaultFigmaGen,
            properties: AssetImageProperties(from: asset),
            images: assetImages
        )
        return AssetImageSet(contents: contents)
    }

    private func makeAssetImageSets(for assets: [ImageRenderedNode: ImageAsset]) -> [String: AssetImageSet] {
        assets.values.reduce(into: [:]) { result, asset in
            result[asset.name] = makeAssetImageSet(for: asset)
        }
    }

    private func saveImageFiles(node: ImageRenderedNode, asset: ImageAsset) -> Promise<Void> {
        let promises = node.urls.compactMap { scale, url in
            asset.filePaths[scale].map { self.dataProvider.saveData(from: url, to: $0) }
        }

        return when(fulfilled: promises)
    }

    private func saveAssetFolders(
        assets: [ImageComponentSetAsset: AssetFolder],
        groupByFrame: Bool,
        in folderPath: String
    ) throws -> Promise<Void> {
        let folderPath = Path(folderPath)

        if folderPath.exists {
            try folderPath.delete()
        }

        let promises = assets.map { asset, folder in
            assetsProvider.saveAssetFolder(
                folder,
                in: resolveFolderPath(groupByFrame: groupByFrame, setAsset: asset, folderPath: folderPath).string
            )
        }

        return when(fulfilled: promises).asVoid()
    }

    private func saveImageFiles(assets: [ImageComponentSetAsset]) -> Promise<Void> {
        let promises = assets.flatMap { setAsset in
            setAsset.assets.map { node, asset in
                saveImageFiles(node: node, asset: asset)
            }
        }

        return when(fulfilled: promises)
    }

    // MARK: -

    func saveImages(
        nodes: [ImageComponentSetRenderedNode],
        format: ImageFormat,
        preserveVectorData: Bool,
        groupByFrame: Bool,
        namingStyle: ImageNamingStyle,
        in folderPath: String
    ) -> Promise<[ImageComponentSetAsset]> {
        perform(on: DispatchQueue.global(qos: .userInitiated)) {
            self.makeAssets(
                for: nodes,
                format: format,
                preserveVectorData: preserveVectorData,
                groupByFrame: groupByFrame,
                namingStyle: namingStyle,
                folderPath: Path(folderPath)
            )
        }.nest { assets in
            perform(on: DispatchQueue.global(qos: .userInitiated)) {
                assets.reduce(into: [:]) { result, asset in
                    result[asset] = AssetFolder(
                        imageSets: self.makeAssetImageSets(for: asset.assets),
                        contents: AssetFolderContents(info: .defaultFigmaGen)
                    )
                }
            }.then { assets in
                try self.saveAssetFolders(assets: assets, groupByFrame: groupByFrame, in: folderPath)
            }.then {
                self.saveImageFiles(assets: assets)
            }
        }
    }
}

extension ImageScale {

    // MARK: - Instance Properties

    fileprivate var assetImageScale: AssetImageScale? {
        switch self {
        case .none:
            return nil

        case .scale1x:
            return .scale1x

        case .scale2x:
            return .scale2x

        case .scale3x:
            return .scale3x
        }
    }
}

extension AssetImageProperties {

    fileprivate init?(from imageAsset: ImageAsset) {
        guard imageAsset.preserveVectorData else {
            return nil
        }
        self.init(preserveVectorRepresentation: imageAsset.preserveVectorData)
    }
}
