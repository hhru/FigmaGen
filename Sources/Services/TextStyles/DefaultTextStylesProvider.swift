//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation
import PromiseKit

final class DefaultTextStylesProvider {

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

    private func extractTextColor(from nodeInfo: FigmaVectorNodeInfo, styles: [String: FigmaStyle]) -> Color? {
        let nodeStyleName = nodeInfo
            .styleID(of: .fill)
            .flatMap { styles[$0] }?
            .name

        let nodeSingleSolidFill = nodeInfo
            .fills
            .flatMap { $0.count == 1 ? $0.first : nil }
            .flatMap { $0.type == .solid ? $0 : nil }

        guard let nodeFillColor = nodeSingleSolidFill?.color else {
            return nil
        }

        return Color(
            name: nodeStyleName,
            red: nodeFillColor.r,
            green: nodeFillColor.g,
            blue: nodeFillColor.b,
            alpha: nodeFillColor.a
        )
    }

    private func extractTextStyle(from node: FigmaNode, styles: [String: FigmaStyle]) throws -> TextStyle? {
        guard case let .text(info: nodeInfo, payload: textNodePayload) = node.type else {
            return nil
        }

        guard let nodeStyleID = nodeInfo.styleID(of: .text) else {
            return nil
        }

        guard let nodeStyle = styles[nodeStyleID], nodeStyle.type == .text  else {
            throw TextStylesError.styleNotFound(nodeName: node.name, nodeID: node.id)
        }

        guard let nodeStyleName = nodeStyle.name, !nodeStyleName.isEmpty else {
            throw TextStylesError.invalidStyleName(nodeName: node.name, nodeID: node.id)
        }

        guard let nodeTextStyle = textNodePayload.style else {
            throw TextStylesError.textStyleNotFound(nodeName: node.name, nodeID: node.id)
        }

        guard let fontFamily = nodeTextStyle.fontFamily, !fontFamily.isEmpty else {
            throw TextStylesError.invalidFontFamily(nodeName: node.name, nodeID: node.id)
        }

        guard let fontPostScriptName = nodeTextStyle.fontPostScriptName, !fontPostScriptName.isEmpty else {
            throw TextStylesError.invalidFontName(nodeName: node.name, nodeID: node.id)
        }

        guard let fontWeight = nodeTextStyle.fontWeight else {
            throw TextStylesError.invalidFontWeight(nodeName: node.name, nodeID: node.id)
        }

        guard let fontSize = nodeTextStyle.fontSize else {
            throw TextStylesError.invalidFontSize(nodeName: node.name, nodeID: node.id)
        }

        guard let textColor = extractTextColor(from: nodeInfo, styles: styles) else {
            throw TextStylesError.invalidTextColor(nodeName: node.name, nodeID: node.id)
        }

        return TextStyle(
            name: nodeStyleName,
            fontFamily: fontFamily,
            fontPostScriptName: fontPostScriptName,
            fontWeight: fontWeight,
            fontSize: fontSize,
            textColor: textColor,
            paragraphSpacing: nodeTextStyle.paragraphSpacing,
            paragraphIndent: nodeTextStyle.paragraphIndent,
            lineHeight: nodeTextStyle.lineHeight,
            letterSpacing: nodeTextStyle.letterSpacing
        )
    }

    private func extractTextStyles(
        from file: FigmaFile,
        includingNodes includingNodeIDs: [String]?,
        excludingNodes excludingNodeIDs: [String]?
    ) throws -> [TextStyle] {
        return try nodesExtractor
            .extractNodes(from: file, including: includingNodeIDs, excluding: excludingNodeIDs)
            .lazy
            .compactMap { try extractTextStyle(from: $0, styles: file.styles ?? [:]) }
            .reduce(into: []) { result, textStyle in
                if !result.contains(textStyle) {
                    result.append(textStyle)
                }
            }
    }
}

extension DefaultTextStylesProvider: TextStylesProvider {

    // MARK: - Instance Methods

    func fetchTextStyles(
        fileKey: String,
        includingNodes includingNodeIDs: [String]?,
        excludingNodes excludingNodeIDs: [String]?
    ) -> Promise<[TextStyle]> {
        return firstly {
            self.apiProvider.request(route: FigmaAPIFileRoute(fileKey: fileKey))
        }.map(on: DispatchQueue.global(qos: .userInitiated)) { file in
            try self.extractTextStyles(
                from: file,
                includingNodes: includingNodeIDs,
                excludingNodes: excludingNodeIDs
            )
        }
    }
}
