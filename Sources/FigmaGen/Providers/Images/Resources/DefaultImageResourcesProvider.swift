import Foundation
import FigmaGenTools
import PromiseKit
import PathKit

final class DefaultImageResourcesProvider: ImageResourcesProvider, ImagesFolderPathResolving {

    // MARK: - Instance Properties

    let dataProvider: DataProvider
    let postProcessor: ImageResourcesPostProcessor

    // MARK: - Initializers

    init(dataProvider: DataProvider, postProcessor: ImageResourcesPostProcessor) {
        self.dataProvider = dataProvider
        self.postProcessor = postProcessor
    }

    // MARK: - Instance Methods

    private func resolveFileName(
        for node: ImageRenderedNode,
        setNode: ImageComponentSetRenderedNode,
        namingStyle: ImageNamingStyle
    ) -> String {
        let fileName = setNode.type == .component ? node.base.name : "\(setNode.name) \(node.base.name)"

        switch namingStyle {
        case .camelCase:
            return fileName.camelized

        case .snakeCase:
            return fileName.snakeCased
        }
    }

    private func makeResource(
        for node: ImageRenderedNode,
        setNode: ImageComponentSetRenderedNode,
        parameters: ImagesParameters,
        folderPath: Path
    ) -> ImageResource {
        let fileName = resolveFileName(for: node, setNode: setNode, namingStyle: parameters.namingStyle)

        let folderPath = resolveFolderPath(
            groupByFrame: parameters.groupByFrame,
            groupByComponentSet: parameters.groupByComponentSet,
            setNode: setNode,
            folderPath: folderPath
        )

        let fileExtension = parameters.format.fileExtension

        let filePaths = node.urls.keys.reduce(into: [:]) { result, scale in
            result[scale] = folderPath
                .appending(fileName: fileName.appending(scale.fileNameSuffix), extension: fileExtension)
                .string
        }

        return ImageResource(fileName: fileName, fileExtension: fileExtension, filePaths: filePaths)
    }

    private func makeResources(
        for nodes: [ImageComponentSetRenderedNode],
        parameters: ImagesParameters,
        folderPath: Path
    ) -> [ImageRenderedNode: ImageResource] {
        var resources: [ImageRenderedNode: ImageResource] = [:]

        nodes.forEach { setNode in
            setNode.components.forEach { node in
                resources[node] = makeResource(
                    for: node,
                    setNode: setNode,
                    parameters: parameters,
                    folderPath: folderPath
                )
            }
        }

        return resources
    }

    private func saveImageFiles(
        node: ImageRenderedNode,
        resource: ImageResource,
        postProcessor: String?
    ) -> Promise<Void> {
        let promises = node.urls.compactMap { scale, url in
            resource.filePaths[scale].map { filePath in
                self.dataProvider
                    .saveData(from: url, to: filePath)
                    .done {
                        if let postProcessor {
                            try self.postProcessor.execute(postProcessorPath: postProcessor, filePath: filePath)
                        }
                    }
            }
        }

        return when(fulfilled: promises)
    }

    private func saveImageFiles(
        resources: [ImageRenderedNode: ImageResource],
        postProcessor: String?,
        in folderPath: Path
    ) throws -> Promise<Void> {
        if folderPath.exists {
            try folderPath.delete()
        }

        let promises = resources.map { node, resource in
            saveImageFiles(node: node, resource: resource, postProcessor: postProcessor)
        }

        return when(fulfilled: promises)
    }

    // MARK: -

    func saveImages(
        nodes: [ImageComponentSetRenderedNode],
        parameters: ImagesParameters,
        in folderPath: String
    ) -> Promise<[ImageRenderedNode: ImageResource]> {
        perform(on: DispatchQueue.global(qos: .userInitiated)) {
            self.makeResources(
                for: nodes,
                parameters: parameters,
                folderPath: Path(folderPath)
            )
        }.nest { resources in
            try self.saveImageFiles(resources: resources, postProcessor: parameters.postProcessor, in: Path(folderPath))
        }
    }
}
