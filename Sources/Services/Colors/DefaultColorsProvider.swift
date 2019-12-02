//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation
import PromiseKit

final class DefaultColorsProvider {

    // MARK: - Instance Properties

    let apiProvider: FigmaAPIProvider
    let nodesExtractor: NodesExtractor

    // MARK: - Initializers

    init(
        apiProvider: FigmaAPIProvider,
        nodesExtractor: NodesExtractor
    ) {
        self.apiProvider = apiProvider
        self.nodesExtractor = nodesExtractor
    }

    // MARK: - Instance Methods

    private func extractColor(from node: FigmaNode, styles: [String: FigmaStyle]) throws -> Color? {
        guard let vectorNodeInfo = node.vectorInfo, let nodeStyleID = vectorNodeInfo.styleID(of: .fill) else {
            return nil
        }

        guard let nodeStyle = styles[nodeStyleID] else {
            throw ColorsError.styleNotFound(nodeName: node.name, nodeID: node.id)
        }

        guard let nodeStyleName = nodeStyle.name, !nodeStyleName.isEmpty else {
            throw ColorsError.invalidStyleName(nodeName: node.name, nodeID: node.id)
        }

        let nodeSingleSolidFill = vectorNodeInfo
            .fills
            .flatMap { $0.count == 1 ? $0.first : nil }
            .flatMap { $0.type == .solid ? $0 : nil }

        guard let nodeFill = nodeSingleSolidFill else {
            return nil
        }

        guard let nodeFillColor = nodeFill.color else {
            throw ColorsError.colorNotFound(nodeName: node.name, nodeID: node.id)
        }

        return Color(
            name: nodeStyleName,
            red: nodeFillColor.r,
            green: nodeFillColor.g,
            blue: nodeFillColor.b,
            alpha: nodeFillColor.a
        )
    }

    private func extractColors(
        from file: FigmaFile,
        includingNodes includingNodeIDs: [String]?,
        excludingNodes excludingNodeIDs: [String]?
    ) throws -> [Color] {
        let styles = file
            .styles?
            .filter { $0.value.type == .fill } ?? [:]

        return try nodesExtractor
            .extractNodes(from: file, including: includingNodeIDs, excluding: excludingNodeIDs)
            .lazy
            .compactMap { try extractColor(from: $0, styles: styles) }
            .reduce(into: []) { result, color in
                if !result.contains(color) {
                    result.append(color)
                }
            }
    }
}

extension DefaultColorsProvider: ColorsProvider {

    // MARK: - Instance Methods

    func fetchColors(
        fileKey: String,
        includingNodes includingNodeIDs: [String]?,
        excludingNodes excludingNodeIDs: [String]?
    ) -> Promise<[Color]> {
        return firstly {
            self.apiProvider.request(route: FigmaAPIFileRoute(fileKey: fileKey))
        }.map(on: DispatchQueue.global(qos: .userInitiated)) { file in
            try self.extractColors(
                from: file,
                includingNodes: includingNodeIDs,
                excludingNodes: excludingNodeIDs
            )
        }
    }
}
