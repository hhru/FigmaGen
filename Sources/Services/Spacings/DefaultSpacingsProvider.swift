//
// FigmaGen
// Copyright © 2020 HeadHunter
// MIT Licence
//

import Foundation
import PromiseKit

final class DefaultSpacingsProvider {

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

    private func extractSpacing(from node: FigmaNode) throws -> Spacing? {
        guard case .component(let nodeInfo) = node.type else {
            return nil
        }
        guard !node.name.isEmpty else {
            throw SpacingsError.invalidSpacingName(nodeName: node.name, nodeID: node.id)
        }
        guard let value = nodeInfo.absoluteBoundingBox.height else {
            throw SpacingsError.spacingNotFound(nodeName: node.name, nodeID: node.id)
        }
        return Spacing(name: node.name, value: value)
    }

    private func extractSpacings(
        from file: FigmaFile,
        includingNodes includingNodeIDs: [String]?,
        excludingNodes excludingNodeIDs: [String]?
    ) throws -> [Spacing] {
        return try nodesExtractor
            .extractNodes(from: file, including: includingNodeIDs, excluding: excludingNodeIDs)
            .lazy
            .compactMap { try extractSpacing(from: $0) }
    }
}

extension DefaultSpacingsProvider: SpacingsProvider {

    // MARK: - Instance Methods

    func fetchSpacings(
        fileKey: String,
        includingNodes includingNodeIDs: [String]?,
        excludingNodes excludingNodeIDs: [String]?
    ) -> Promise<[Spacing]> {
        return firstly {
            self.apiProvider.request(route: FigmaAPIFileRoute(fileKey: fileKey))
        }.map(on: DispatchQueue.global(qos: .userInitiated)) { file in
            try self.extractSpacings(
                from: file,
                includingNodes: includingNodeIDs,
                excludingNodes: excludingNodeIDs
            )
        }
    }
}
