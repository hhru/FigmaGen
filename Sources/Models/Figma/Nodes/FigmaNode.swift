//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Properties that exist on every node.
/// A node can have additional properties associated with it depending on its node type.
/// Get more info: https://www.figma.com/developers/api#node-types
struct FigmaNode: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case isVisible = "visible"
    }

    private enum CodingValues {
        static let documentType = "DOCUMENT"
        static let canvasType = "CANVAS"
        static let frameType = "FRAME"
        static let groupType = "GROUP"
        static let vectorType = "VECTOR"
        static let booleanOperationType = "BOOLEAN_OPERATION"
        static let starType = "STAR"
        static let lineType = "LINE"
        static let ellipseType = "ELLIPSE"
        static let regularPolygonType = "REGULAR_POLYGON"
        static let rectangleType = "RECTANGLE"
        static let textType = "TEXT"
        static let sliceType = "SLICE"
        static let componentType = "COMPONENT"
        static let instanceType = "INSTANCE"
    }

    // MARK: - Instance Properties

    /// A string uniquely identifying this node within the document.
    let id: String

    /// The name given to the node by the user in the tool.
    let name: String

    /// Node type.
    var type: FigmaNodeType

    /// Whether or not the node is visible on the canvas.
    /// Defaults to `true`.
    let isVisible: Bool?

    /// An array of childs attached to the node.
    var children: [FigmaNode]? {
        switch type {
        case .unknown, .slice, .vector, .star, .line, .ellipse, .regularPolygon, .rectangle, .text:
            return nil

        case let .booleanOperation(info: _, payload: payload):
            return payload.children

        case let .document(info: documentNodeInfo):
            return documentNodeInfo.children

        case let .canvas(info: canvasNodeInfo):
            return canvasNodeInfo.children

        case let .frame(info: frameNodeInfo),
             let .group(info: frameNodeInfo),
             let .component(info: frameNodeInfo),
             let .instance(info: frameNodeInfo, payload: _):
            return frameNodeInfo.children
        }
    }

    /// Vector node specific proprties.
    var vectorInfo: FigmaVectorNodeInfo? {
        switch type {
        case .unknown,
             .document,
             .canvas,
             .frame,
             .group,
             .booleanOperation,
             .slice,
             .component,
             .instance:
            return nil

        case let .vector(info: nodeInfo),
             let .star(info: nodeInfo),
             let .line(info: nodeInfo),
             let .ellipse(info: nodeInfo),
             let .regularPolygon(info: nodeInfo),
             let .rectangle(info: nodeInfo, payload: _),
             let .text(info: nodeInfo, payload: _):
            return nodeInfo
        }
    }

    // MARK: - Initializers

    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    init(from decoder: Decoder) throws {
        // swiftlint:disable:previous function_body_length

        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(forKey: .id)
        name = try container.decode(forKey: .name)

        isVisible = try container.decodeIfPresent(forKey: .isVisible)

        switch try container.decode(String.self, forKey: .type) {
        case CodingValues.documentType:
            type = .document(info: try FigmaDocumentNodeInfo(from: decoder))

        case CodingValues.canvasType:
            type = .canvas(info: try FigmaCanvasNodeInfo(from: decoder))

        case CodingValues.frameType:
            type = .frame(info: try FigmaFrameNodeInfo(from: decoder))

        case CodingValues.groupType:
            type = .group(info: try FigmaFrameNodeInfo(from: decoder))

        case CodingValues.vectorType:
            type = .vector(info: try FigmaVectorNodeInfo(from: decoder))

        case CodingValues.booleanOperationType:
            type = .booleanOperation(
                info: try FigmaVectorNodeInfo(from: decoder),
                payload: try FigmaBooleanOperationNodePayload(from: decoder)
            )

        case CodingValues.starType:
            type = .star(info: try FigmaVectorNodeInfo(from: decoder))

        case CodingValues.lineType:
            type = .line(info: try FigmaVectorNodeInfo(from: decoder))

        case CodingValues.ellipseType:
            type = .ellipse(info: try FigmaVectorNodeInfo(from: decoder))

        case CodingValues.regularPolygonType:
            type = .regularPolygon(info: try FigmaVectorNodeInfo(from: decoder))

        case CodingValues.rectangleType:
            type = .rectangle(
                info: try FigmaVectorNodeInfo(from: decoder),
                payload: try FigmaRectangleNodePayload(from: decoder)
            )

        case CodingValues.textType:
            type = .text(
                info: try FigmaVectorNodeInfo(from: decoder),
                payload: try FigmaTextNodePayload(from: decoder)
            )

        case CodingValues.sliceType:
            type = .slice(info: try FigmaSliceNodeInfo(from: decoder))

        case CodingValues.componentType:
            type = .component(info: try FigmaFrameNodeInfo(from: decoder))

        case CodingValues.instanceType:
            type = .instance(
                info: try FigmaFrameNodeInfo(from: decoder),
                payload: try FigmaInstanceNodePayload(from: decoder)
            )

        default:
            type = .unknown
        }
    }
}
