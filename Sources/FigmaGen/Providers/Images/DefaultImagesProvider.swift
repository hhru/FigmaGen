import Foundation
import FigmaGenTools
import PromiseKit

final class DefaultImagesProvider: ImagesProvider {

    // MARK: - Instance Properties

    let filesProvider: FigmaFilesProvider
    let nodesProvider: FigmaNodesProvider
    let imageRenderProvider: ImageRenderProvider
    let imageAssetsProvider: ImageAssetsProvider
    let imageResourcesProvider: ImageResourcesProvider

    // MARK: - Initializers

    init(
        filesProvider: FigmaFilesProvider,
        nodesProvider: FigmaNodesProvider,
        imageRenderProvider: ImageRenderProvider,
        imageAssetsProvider: ImageAssetsProvider,
        imageResourcesProvider: ImageResourcesProvider
    ) {
        self.filesProvider = filesProvider
        self.nodesProvider = nodesProvider
        self.imageRenderProvider = imageRenderProvider
        self.imageAssetsProvider = imageAssetsProvider
        self.imageResourcesProvider = imageResourcesProvider
    }

    // MARK: - Instance Methods

    private func extractImageNode(
        from node: FigmaNode,
        info: FigmaFrameNodeInfo,
        components: [String: FigmaComponent],
        onlyExportables: Bool
    ) throws -> ImageNode? {
        guard !onlyExportables || !info.exportSettings.isEmptyOrNil else {
            return nil
        }

        guard let nodeComponent = components[node.id] else {
            throw ImagesProviderError(code: .componentNotFound, nodeID: node.id, nodeName: node.name)
        }

        guard let nodeComponentName = nodeComponent.name, !nodeComponentName.isEmpty else {
            throw ImagesProviderError(code: .invalidComponentName, nodeID: node.id, nodeName: node.name)
        }

        return ImageNode(
            id: node.id,
            name: nodeComponentName,
            description: nodeComponent.description
        )
    }

    private func extractImageNode(
        from node: FigmaNode,
        components: [String: FigmaComponent],
        onlyExportables: Bool
    ) throws -> ImageNode? {
        guard case .component(let info) = node.type else {
            return nil
        }

        return try extractImageNode(
            from: node,
            info: info,
            components: components,
            onlyExportables: onlyExportables
        )
    }

    private func extractImageSetNode(
        from node: FigmaNode,
        components: [String: FigmaComponent],
        onlyExportables: Bool
    ) throws -> ImageComponentSetNode? {
        switch node.type {
        case .component(let info):
            guard components[node.id]?.componentSetID == nil else {
                return nil
            }

            let imageNode = try extractImageNode(
                from: node,
                info: info,
                components: components,
                onlyExportables: onlyExportables
            )

            guard let imageNode else {
                return nil
            }

            return ImageComponentSetNode(name: imageNode.name, parentName: node.parent?.name, component: imageNode)

        case .componentSet:
            guard let children = node.children else {
                return nil
            }

            let nodes = try children
                .lazy
                .filter { $0.isVisible ?? true }
                .compactMap { node in
                    try extractImageNode(
                        from: node,
                        components: components,
                        onlyExportables: onlyExportables
                    )
                }

            guard let nodeComponentSetName = node.name, !nodeComponentSetName.isEmpty else {
                throw ImagesProviderError(code: .invalidComponentName, nodeID: node.id, nodeName: node.name)
            }

            return ImageComponentSetNode(name: nodeComponentSetName, parentName: node.parent?.name, components: nodes)

        default:
            return nil
        }
    }

    private func extractImageSetNodes(
        from nodes: [FigmaNode],
        of file: FigmaFile,
        onlyExportables: Bool
    ) throws -> [ImageComponentSetNode] {
        let components = file.components ?? [:]

        return try nodes
            .lazy
            .filter { $0.isVisible ?? true }
            .compactMap { node in
                try extractImageSetNode(
                    from: node,
                    components: components,
                    onlyExportables: onlyExportables
                )
            }
            .reduce(into: []) { result, node in
                if !result.contains(node) {
                    result.append(node)
                }
            }
    }

    private func saveAssetImagesIfNeeded(
        nodes: [ImageComponentSetRenderedNode],
        format: ImageFormat,
        preserveVectorData: Bool,
        groupByFrame: Bool,
        namingStyle: ImageNamingStyle,
        in assets: String?
    ) -> Promise<[ImageComponentSetAsset]> {
        assets.map { folderPath in
            imageAssetsProvider.saveImages(
                nodes: nodes,
                format: format,
                preserveVectorData: preserveVectorData,
                groupByFrame: groupByFrame,
                namingStyle: namingStyle,
                in: folderPath
            )
        } ?? .value([])
    }

    private func saveResourceImagesIfNeeded(
        nodes: [ImageComponentSetRenderedNode],
        groupByFrame: Bool,
        format: ImageFormat,
        postProcessor: String?,
        namingStyle: ImageNamingStyle,
        in resources: String?
    ) -> Promise<[ImageRenderedNode: ImageResource]> {
        resources.map { folderPath in
            imageResourcesProvider.saveImages(
                nodes: nodes,
                groupByFrame: groupByFrame,
                format: format,
                postProcessor: postProcessor,
                namingStyle: namingStyle,
                in: folderPath
            )
        } ?? .value([:])
    }

    private func saveAssetImagesIfNeeded(
        nodes: [ImageComponentSetRenderedNode],
        parameters: ImagesParameters
    ) -> Promise<[ImageSet]> {
        when(
            fulfilled: self.saveAssetImagesIfNeeded(
                nodes: nodes,
                format: parameters.format,
                preserveVectorData: parameters.preserveVectorData,
                groupByFrame: parameters.groupByFrame,
                namingStyle: parameters.namingStyle,
                in: parameters.assets
            ),
            self.saveResourceImagesIfNeeded(
                nodes: nodes,
                groupByFrame: parameters.groupByFrame,
                format: parameters.format,
                postProcessor: parameters.postProcessor,
                namingStyle: parameters.namingStyle,
                in: parameters.resources
            )
        )
        .map { assets, resources in
            nodes.map { node in
                ImageSet(
                    name: node.name,
                    images: node.components.map { imageNode in
                        Image(
                            node: imageNode,
                            format: parameters.format,
                            asset: assets
                                .first { $0.name == node.name }?
                                .assets[imageNode],
                            resource: resources[imageNode]
                        )
                    }
                )
            }
        }
    }

    // MARK: -

    func fetchImages(
        from file: FileParameters,
        nodes: NodesParameters,
        parameters: ImagesParameters
    ) -> Promise<[ImageSet]> {
        firstly {
            self.filesProvider.fetchFile(file)
        }.then { figmaFile in
            self.nodesProvider.fetchNodes(nodes, from: figmaFile).map { figmaNodes in
                try self.extractImageSetNodes(
                    from: figmaNodes,
                    of: figmaFile,
                    onlyExportables: parameters.onlyExportables
                )
            }
        }.then { nodes in
            self.imageRenderProvider.renderImages(
                of: file,
                nodes: nodes,
                format: parameters.format,
                scales: parameters.scales,
                useAbsoluteBounds: parameters.useAbsoluteBounds
            )
        }.then { nodes in
            self.saveAssetImagesIfNeeded(
                nodes: nodes,
                parameters: parameters
            )
        }
    }
}
