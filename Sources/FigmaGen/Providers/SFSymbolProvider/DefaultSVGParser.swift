import Foundation

final class DefaultSVGParser: SVGParser {

    // MARK: - Instance Methods

    func parse(data: Data) throws -> SVGDocument {
        let parser = XMLParser(data: data)
        let documentBuilder = SVGDocumentBuilder()

        parser.delegate = documentBuilder
        parser.shouldResolveExternalEntities = false
        parser.shouldProcessNamespaces = false

        guard parser.parse() else {
            throw parser.parserError ?? SVGParserError.invalidXML
        }

        return SVGDocument(canvas: documentBuilder.canvas, paths: documentBuilder.paths)
    }
}

private final class SVGDocumentBuilder: NSObject, XMLParserDelegate {

    // MARK: - Nested Types

    private enum ElementName {

        static let svg = "svg"
        static let group = "g"
        static let path = "path"

        static let definitions: Set<String> = ["clipPath", "defs", "mask", "pattern", "symbol"]
    }

    private enum AttributeName {

        static let id = "id"
        static let data = "d"
        static let fill = "fill"
        static let fillRule = "fill-rule"
        static let style = "style"
        static let transform = "transform"
        static let width = "width"
        static let height = "height"
        static let viewBox = "viewBox"
    }

    private struct Group {

        let id: String?
        let fill: SVGColor?
        let transform: String?
    }

    // MARK: - Instance Properties

    private(set) var canvas: SVGCanvas?
    private(set) var paths: [SVGPath] = []

    private var openGroups: [Group] = []
    private var definitionsDepth = 0

    // MARK: - Instance Methods

    private func makeCanvas(from attributes: [String: String]) -> SVGCanvas? {
        if
            let width = length(from: attributes[AttributeName.width]),
            let height = length(from: attributes[AttributeName.height]),
            width > 0.0,
            height > 0.0 {
            return SVGCanvas(width: width, height: height)
        }

        let viewBox = attributes[AttributeName.viewBox]?
            .split { $0 == " " || $0 == "," }
            .compactMap { Double($0) }

        guard let viewBox, viewBox.count == 4, viewBox[2] > 0.0, viewBox[3] > 0.0 else {
            return nil
        }

        return SVGCanvas(width: viewBox[2], height: viewBox[3])
    }

    private func length(from value: String?) -> Double? {
        value
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .map { $0.hasSuffix("px") ? String($0.dropLast(2)) : $0 }
            .flatMap { Double($0) }
    }

    private func makeGroup(from attributes: [String: String]) -> Group {
        Group(
            id: attributes[AttributeName.id],
            fill: fillColor(from: attributes) ?? openGroups.last?.fill,
            transform: attributes[AttributeName.transform]
        )
    }

    private func makePath(from attributes: [String: String]) -> SVGPath {
        SVGPath(
            id: attributes[AttributeName.id],
            data: attributes[AttributeName.data],
            fillRule: attributes[AttributeName.fillRule],
            fill: fillColor(from: attributes) ?? openGroups.last?.fill,
            transform: attributes[AttributeName.transform],
            groupIDs: openGroups.compactMap(\.id),
            groupTransforms: openGroups.compactMap(\.transform)
        )
    }

    private func fillColor(from attributes: [String: String]) -> SVGColor? {
        guard let value = attributes[AttributeName.fill] ?? styleFill(from: attributes) else {
            return nil
        }

        switch value.lowercased().replacingOccurrences(of: " ", with: "") {
        case "black", "#000", "#000000", "rgb(0,0,0)":
            return .black

        default:
            return .other(value)
        }
    }

    private func styleFill(from attributes: [String: String]) -> String? {
        guard let style = attributes[AttributeName.style] else {
            return nil
        }

        for declaration in style.split(separator: ";") {
            let nameAndValue = declaration
                .split(separator: ":", maxSplits: 1)
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

            if nameAndValue.count == 2, nameAndValue[0].lowercased() == AttributeName.fill {
                return nameAndValue[1]
            }
        }

        return nil
    }

    // MARK: - XMLParserDelegate

    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String: String] = [:]
    ) {
        if ElementName.definitions.contains(elementName) {
            definitionsDepth += 1
        }

        switch elementName {
        case ElementName.svg where canvas == nil:
            canvas = makeCanvas(from: attributeDict)

        case ElementName.group:
            openGroups.append(makeGroup(from: attributeDict))

        case ElementName.path where definitionsDepth == 0:
            paths.append(makePath(from: attributeDict))

        default:
            break
        }
    }

    func parser(
        _ parser: XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?
    ) {
        if ElementName.definitions.contains(elementName) {
            definitionsDepth = max(definitionsDepth - 1, 0)
        }

        if elementName == ElementName.group {
            _ = openGroups.popLast()
        }
    }
}
