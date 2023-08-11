import Foundation
import FigmaGenTools
import PromiseKit
import PathKit

final class DefaultImageResourcesProvider: ImageResourcesProvider, ImagesFolderPathResolving {

    // MARK: - Instance Properties

    let dataProvider: DataProvider

    // MARK: - Initializers

    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }

    // MARK: - Instance Methods

    private func makeResource(
        for node: ImageRenderedNode,
        setNode: ImageComponentSetRenderedNode,
        groupByFrame: Bool,
        format: ImageFormat,
        folderPath: Path
    ) -> ImageResource {
        let fileName = setNode.isSingleComponent
            ? node.base.name.camelized
            : "\(setNode.name) \(node.base.name)".camelized

        let folderPath = resolveFolderPath(groupByFrame: groupByFrame, setNode: setNode, folderPath: folderPath)
        let fileExtension = format.fileExtension

        let filePaths = node.urls.keys.reduce(into: [:]) { result, scale in
            result[scale] = folderPath
                .appending(fileName: fileName.appending(scale.fileNameSuffix), extension: fileExtension)
                .string
        }

        return ImageResource(fileName: fileName, fileExtension: fileExtension, filePaths: filePaths)
    }

    private func makeResources(
        for nodes: [ImageComponentSetRenderedNode],
        groupByFrame: Bool,
        format: ImageFormat,
        folderPath: Path
    ) -> [ImageRenderedNode: ImageResource] {
        var resources: [ImageRenderedNode: ImageResource] = [:]

        nodes.forEach { setNode in
            setNode.components.forEach { node in
                resources[node] = makeResource(
                    for: node,
                    setNode: setNode,
                    groupByFrame: groupByFrame,
                    format: format,
                    folderPath: folderPath
                )
            }
        }

        return resources
    }

    private func saveImageFiles(node: ImageRenderedNode, resource: ImageResource) -> Promise<Void> {
        let promises = node.urls.compactMap { scale, url in
            resource.filePaths[scale].map { self.dataProvider.saveData(from: url, to: $0) }
        }

        return when(fulfilled: promises)
    }

    private func saveImageFiles(
        resources: [ImageRenderedNode: ImageResource],
        in folderPath: Path
    ) throws -> Promise<Void> {
        if folderPath.exists {
            try folderPath.delete()
        }

        let promises = resources.map { node, resource in
            saveImageFiles(node: node, resource: resource)
        }

        return when(fulfilled: promises)
    }

    // MARK: -

    func saveImages(
        nodes: [ImageComponentSetRenderedNode],
        groupByFrame: Bool,
        format: ImageFormat,
        in folderPath: String
    ) -> Promise<[ImageRenderedNode: ImageResource]> {
        perform(on: DispatchQueue.global(qos: .userInitiated)) {
            self.makeResources(
                for: nodes,
                groupByFrame: groupByFrame,
                format: format,
                folderPath: Path(folderPath)
            )
        }.nest { resources in
            try self.saveImageFiles(resources: resources, in: Path(folderPath))
        }
    }
}
