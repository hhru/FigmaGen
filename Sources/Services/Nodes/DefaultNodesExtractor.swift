//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

final class DefaultNodesExtractor {

    // MARK: - Instance Methods

    private func extractNodes(
        from node: FigmaNode,
        including includingNodeIDs: inout Set<String>,
        excluding excludingNodeIDs: inout Set<String>,
        forceInclude: Bool
    ) -> [FigmaNode] {
        let isIncludingNode = includingNodeIDs.remove(node.id) != nil
        let isExcludingNode = excludingNodeIDs.remove(node.id) != nil

        var nodes: [FigmaNode] = []

        guard !isExcludingNode else {
            return []
        }

        if isIncludingNode || forceInclude {
            nodes.append(node)
        }

        guard let children = node.children, !children.isEmpty else {
            return nodes
        }

        return nodes + children.flatMap { child in
            return extractNodes(
                from: child,
                including: &includingNodeIDs,
                excluding: &excludingNodeIDs,
                forceInclude: forceInclude || isIncludingNode
            )
        }
    }

    private func resolveNodeID(_ nodeID: String) throws -> String {
        guard let unescapedNodeID = nodeID.removingPercentEncoding else {
            throw NodesError.invalidNodeID(nodeID)
        }

        return unescapedNodeID
    }

    private func resolveNodeIDs(_ nodeIDs: [String]?, defaultNodeIDs: Set<String>) throws -> Set<String> {
        guard let nodeIDs = nodeIDs, !nodeIDs.isEmpty else {
            return defaultNodeIDs
        }

        return try Set(nodeIDs.map { try resolveNodeID($0) })
    }
}

extension DefaultNodesExtractor: NodesExtractor {

    // MARK: - Instance Methods

    func extractNodes(
        from file: FigmaFile,
        including includingNodeIDs: [String]?,
        excluding excludingNodeIDs: [String]?
    ) throws -> [FigmaNode] {
        var includingNodeIDs = try self.resolveNodeIDs(includingNodeIDs, defaultNodeIDs: [file.document.id])
        var excludingNodeIDs = try self.resolveNodeIDs(excludingNodeIDs, defaultNodeIDs: [])

        return extractNodes(
            from: file.document,
            including: &includingNodeIDs,
            excluding: &excludingNodeIDs,
            forceInclude: false
        )
    }
}
