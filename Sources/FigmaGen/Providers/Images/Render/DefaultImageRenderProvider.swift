import Foundation
import PromiseKit

final class DefaultImageRenderProvider: ImageRenderProvider {

    // MARK: - Instance Properties

    let apiProvider: FigmaAPIProvider

    // MARK: - Initializers

    init(apiProvider: FigmaAPIProvider) {
        self.apiProvider = apiProvider
    }

    // MARK: - Instance Methods

    private func extractImageURL(from rawURLs: [String: String?], node: ImageNode) throws -> URL {
        guard let rawURL = rawURLs[node.id]?.flatMap({ $0 }) else {
            throw ImageRenderProviderError(code: .invalidImage, nodeID: node.id, nodeName: node.name)
        }

        guard let url = URL(string: rawURL) else {
            throw ImageRenderProviderError(code: .invalidImageURL, nodeID: node.id, nodeName: node.name)
        }

        return url
    }

    private func extractImageURLs(from rawURLs: [String: String?], nodes: [ImageNode]) throws -> [ImageNode: URL] {
        var urls: [ImageNode: URL] = [:]

        try nodes.forEach { node in
            urls[node] = try self.extractImageURL(from: rawURLs, node: node)
        }

        return urls
    }

    private func makeImageSetRenderedNode(
        for node: ImageComponentSetNode,
        imageURLs: [ImageScale: [ImageNode: URL]]
    ) -> ImageComponentSetRenderedNode {
        let scales = imageURLs.keys

        let renderedNodes = node.components.map { imageNode in
            let nodeImageURLs = scales.reduce(into: [:]) { result, scale in
                result[scale] = imageURLs[scale]?[imageNode]
            }

            return ImageRenderedNode(base: imageNode, urls: nodeImageURLs)
        }

        return ImageComponentSetRenderedNode(name: node.name, components: renderedNodes)
    }

    private func renderImages(
        of file: FileParameters,
        nodes: [ImageComponentSetNode],
        format: ImageFormat,
        scale: ImageScale,
        useAbsoluteBounds: Bool
    ) -> Promise<[ImageNode: URL]> {
        let route = FigmaAPIImagesRoute(
            accessToken: file.accessToken,
            fileKey: file.key,
            fileVersion: file.version,
            nodeIDs: nodes
                .flatMap { $0.components }
                .map { $0.id },
            format: format.figmaFormat,
            scale: scale.figmaScale,
            useAbsoluteBounds: useAbsoluteBounds
        )

        return firstly {
            self.apiProvider.request(route: route)
        }.map(on: DispatchQueue.global(qos: .userInitiated)) { images in
            try self.extractImageURLs(
                from: images.urls,
                nodes: nodes.flatMap { $0.components }
            )
        }
    }

    // MARK: -

    func renderImages(
        of file: FileParameters,
        nodes: [ImageComponentSetNode],
        format: ImageFormat,
        scales: [ImageScale],
        useAbsoluteBounds: Bool
    ) -> Promise<[ImageComponentSetRenderedNode]> {
        guard !nodes.isEmpty else {
            return .value([])
        }

        let promises = scales.map { scale in
            renderImages(of: file, nodes: nodes, format: format, scale: scale, useAbsoluteBounds: useAbsoluteBounds)
                .map { imageURLs in
                    (scale: scale, imageURLs: imageURLs)
                }
        }

        return firstly {
            when(fulfilled: promises)
        }.map(on: DispatchQueue.global(qos: .userInitiated)) { imageURLs in
            Dictionary(imageURLs) { $1 }
        }.map(on: DispatchQueue.global(qos: .userInitiated)) { imageURLs in
            nodes.map { self.makeImageSetRenderedNode(for: $0, imageURLs: imageURLs) }
        }
    }
}

extension ImageFormat {

    // MARK: - Instance Properties

    fileprivate var figmaFormat: FigmaImageFormat {
        switch self {
        case .pdf:
            return .pdf

        case .png:
            return .png

        case .jpg:
            return .jpg

        case .svg:
            return .svg
        }
    }
}

extension ImageScale {

    // MARK: - Instance Properties

    fileprivate var figmaScale: Double {
        switch self {
        case .none, .scale1x:
            return 1.0

        case .scale2x:
            return 2.0

        case .scale3x:
            return 3.0
        }
    }
}
