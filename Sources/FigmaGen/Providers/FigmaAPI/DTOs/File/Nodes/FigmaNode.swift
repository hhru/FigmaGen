import Foundation
import FigmaGenTools

struct FigmaNode: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case rawType = "type"
        case isVisible = "visible"
        case sharedPluginData
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
        static let componentSetType = "COMPONENT_SET"
        static let instanceType = "INSTANCE"
    }

    // MARK: - Instance Properties

    private var _parent: Indirect<FigmaNode>?

    let id: String
    let name: String?
    let rawType: String
    let isVisible: Bool?
    let sharedPluginData: FigmaPluginData?

    let type: FigmaNodeType

    var parent: Self? {
        _parent?.value
    }

    var children: [Self]? {
        switch type {
        case .unknown, .vector, .star, .line, .ellipse, .regularPolygon, .rectangle, .text, .slice:
            return nil

        case let .document(info: documentNodeInfo):
            return documentNodeInfo.children

        case let .canvas(info: canvasNodeInfo):
            return canvasNodeInfo.children?.map { $0.withParent(self) }

        case let .frame(info: frameNodeInfo),
             let .group(info: frameNodeInfo),
             let .component(info: frameNodeInfo),
             let .componentSet(info: frameNodeInfo),
             let .instance(info: frameNodeInfo, payload: _):
            return frameNodeInfo.children?.map { $0.withParent(self) }

        case let .booleanOperation(info: _, payload: payload):
            return payload.children?.map { $0.withParent(self) }
        }
    }

    var frameInfo: FigmaFrameNodeInfo? {
        switch type {
        case .unknown,
             .document,
             .canvas,
             .vector,
             .booleanOperation,
             .star,
             .line,
             .ellipse,
             .regularPolygon,
             .rectangle,
             .text,
             .slice:
            return nil

        case let .frame(info: nodeInfo),
             let .group(info: nodeInfo),
             let .component(info: nodeInfo),
             let .componentSet(info: nodeInfo),
             let .instance(info: nodeInfo, payload: _):
            return nodeInfo
        }
    }

    var vectorInfo: FigmaVectorNodeInfo? {
        switch type {
        case .unknown,
             .document,
             .canvas,
             .frame,
             .group,
             .slice,
             .component,
             .componentSet,
             .instance:
            return nil

        case let .vector(info: nodeInfo),
             let .booleanOperation(info: nodeInfo, payload: _),
             let .star(info: nodeInfo),
             let .line(info: nodeInfo),
             let .ellipse(info: nodeInfo),
             let .regularPolygon(info: nodeInfo),
             let .rectangle(info: nodeInfo, payload: _),
             let .text(info: nodeInfo, payload: _):
            return nodeInfo
        }
    }

    var isComponent: Bool {
        if case .component = type {
            return true
        }

        return false
    }

    var isInstance: Bool {
        if case .instance = type {
            return true
        }

        return false
    }

    // MARK: - Initializers

    init(from decoder: Decoder) throws {
        // swiftlint:disable:previous function_body_length

        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(forKey: .id)
        name = try container.decodeIfPresent(forKey: .name)
        rawType = try container.decode(String.self, forKey: .rawType)
        isVisible = try container.decodeIfPresent(forKey: .isVisible)
        sharedPluginData = try container.decodeIfPresent(forKey: .sharedPluginData)

        switch rawType {
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

        case CodingValues.componentSetType:
            type = .componentSet(info: try FigmaFrameNodeInfo(from: decoder))

        case CodingValues.instanceType:
            type = .instance(
                info: try FigmaFrameNodeInfo(from: decoder),
                payload: try FigmaInstanceNodePayload(from: decoder)
            )

        default:
            type = .unknown
        }
    }

    init(
        id: String,
        name: String?,
        rawType: String,
        isVisible: Bool?,
        sharedPluginData: FigmaPluginData?,
        type: FigmaNodeType,
        parent: Self? = nil
    ) {
        self.id = id
        self.name = name
        self.rawType = rawType
        self.isVisible = isVisible
        self.sharedPluginData = sharedPluginData
        self.type = type
        self._parent = parent.map { Indirect($0) }
    }
}

extension FigmaNode {

    // MARK: - Instance Methods

    func withParent(_ parent: FigmaNode) -> Self {
        Self(
            id: id,
            name: name,
            rawType: rawType,
            isVisible: isVisible,
            sharedPluginData: sharedPluginData,
            type: type,
            parent: parent
        )
    }
}
