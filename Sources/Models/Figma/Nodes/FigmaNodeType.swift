//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Enumeration of known node types.
/// Node type indicates what kind of node you are working with: for example, a Frame node versus a Rectangle node.
/// A node can have additional properties associated with it depending on its node type.
/// Get more info: https://www.figma.com/developers/api#node-types
indirect enum FigmaNodeType: Hashable {

    // MARK: - Enumeration Cases

    case unknown
    case document(info: FigmaDocumentNodeInfo)
    case canvas(info: FigmaCanvasNodeInfo)
    case frame(info: FigmaFrameNodeInfo)
    case group(info: FigmaFrameNodeInfo)
    case vector(info: FigmaVectorNodeInfo)
    case booleanOperation(info: FigmaVectorNodeInfo, payload: FigmaBooleanOperationNodePayload)
    case star(info: FigmaVectorNodeInfo)
    case line(info: FigmaVectorNodeInfo)
    case ellipse(info: FigmaVectorNodeInfo)
    case regularPolygon(info: FigmaVectorNodeInfo)
    case rectangle(info: FigmaVectorNodeInfo, payload: FigmaRectangleNodePayload)
    case text(info: FigmaVectorNodeInfo, payload: FigmaTextNodePayload)
    case slice(info: FigmaSliceNodeInfo)
    case component(info: FigmaFrameNodeInfo)
    case instance(info: FigmaFrameNodeInfo, payload: FigmaInstanceNodePayload)
}
