import Foundation

enum SVGParserError: LocalizedError {

    case invalidXML
    case invalidSVG
    case missingCanvasSize
    case invalidPathData(String)
    case invalidTransform(String)
    case unsupportedArcTransform(String)
    case unsupportedFill(String)

    var errorDescription: String? {
        switch self {
        case .invalidXML:
            return "The SVG file contains invalid XML."

        case .invalidSVG:
            return "The SVG file contains errors."

        case .missingCanvasSize:
            return "The SVG file has no valid width and height attributes and no viewBox."

        case let .invalidPathData(pathData):
            return "The SVG file contains unsupported path data \"\(pathData)\"."

        case let .invalidTransform(transform):
            return "The SVG file contains unsupported transform \"\(transform)\"."

        case let .unsupportedArcTransform(pathData):
            return """
                The SVG file contains an elliptical arc in \"\(pathData)\" \
                under a transform that is not a similarity, which would change the shape of the arc.
                """

        case let .unsupportedFill(fill):
            return "The SVG file contains a path with unsupported fill \"\(fill)\"."
        }
    }
}
