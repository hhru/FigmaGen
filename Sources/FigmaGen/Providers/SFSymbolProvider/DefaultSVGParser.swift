import Foundation

final class DefaultSVGParser: NSObject, SVGParser {

    private enum ElementName {

        static let group = "g"
        static let path = "path"
        static let svg = "svg"

        // Элементы, чьи пути описывают только переиспользуемые определения
        // и никогда не участвуют в видимом рисунке.
        static let ignored: Set<String> = ["clipPath", "defs", "mask", "pattern", "symbol"]
    }

    private enum Attributes {

        static let fill = "fill"
        static let height = "height"
        static let id = "id"
        static let style = "style"
        static let transform = "transform"
        static let viewBox = "viewBox"
        static let width = "width"
    }

    private var canvas: SVGCanvas?
    private var parsedPaths: [SVGPath] = []
    private var groupStack: [SVGGroupContext] = []
    private var ignoredElementDepth = 0

    func parse(id: String, data: Data) throws -> SVGPathsResult {
        parsedPaths.removeAll()
        groupStack.removeAll()
        ignoredElementDepth = 0
        canvas = nil

        let parser = XMLParser(data: data)

        parser.delegate = self
        parser.shouldResolveExternalEntities = false
        parser.shouldProcessNamespaces = false

        guard parser.parse() else {
            throw parser.parserError ?? SVGParserError.invalidXML
        }

        return SVGPathsResult(
            id: id,
            canvas: canvas,
            allPaths: parsedPaths
        )
    }

    private func startGroup(attributes attributeDict: [String: String]) {
        // Заливка наследуется от ближайшей родительской группы, если у самой группы её нет.
        let effectiveFill = fillColor(from: attributeDict) ?? groupStack.last?.fill

        let context = SVGGroupContext(
            id: attributeDict[Attributes.id],
            fill: effectiveFill,
            transform: attributeDict[Attributes.transform]
        )

        groupStack.append(context)
    }

    private func makeCanvas(from attributes: [String: String]) -> SVGCanvas? {
        if
            let width = length(from: attributes[Attributes.width]),
            let height = length(from: attributes[Attributes.height]),
            width > 0.0,
            height > 0.0 {
            return SVGCanvas(width: width, height: height)
        }

        let viewBox = attributes[Attributes.viewBox]?
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

    private func fillColor(from attributes: [String: String]) -> SVGColor? {
        guard let value = fillValue(from: attributes) else {
            return nil
        }

        let normalized = value
            .lowercased()
            .replacingOccurrences(of: " ", with: "")

        switch normalized {
        case "black", "#000", "#000000", "rgb(0,0,0)":
            return .black

        default:
            return .other(value)
        }
    }

    private func fillValue(
        from attributes: [String: String]
    ) -> String? {
        if let fill = attributes[Attributes.fill] {
            return fill
        }

        guard let style = attributes[Attributes.style] else {
            return nil
        }

        let declarations = style.split(separator: ";")

        for declaration in declarations {
            let parts = declaration.split(
                separator: ":",
                maxSplits: 1
            )

            guard parts.count == 2 else {
                continue
            }

            let name = parts[0]
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()

            let value = parts[1]
                .trimmingCharacters(in: .whitespacesAndNewlines)

            guard name == Attributes.fill else {
                continue
            }

            return value
        }

        return nil
    }
}

extension DefaultSVGParser: XMLParserDelegate {

    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String: String] = [:]
    ) {
        if ElementName.ignored.contains(elementName) {
            ignoredElementDepth += 1
        }

        if elementName == ElementName.svg, canvas == nil {
            canvas = makeCanvas(from: attributeDict)
        }

        if elementName == ElementName.group {
            startGroup(attributes: attributeDict)
        }

        guard elementName == ElementName.path, ignoredElementDepth == 0 else {
            return
        }

        let inheritedFill = fillColor(from: attributeDict) ?? groupStack.last?.fill
        let groupIDs = groupStack.compactMap(\.id)

        // Преобразования собираются от внешней группы к внутренней - в том порядке,
        // в каком их применяет SVG. Собственный transform пути добавляет `SVGPath.allTransforms`.
        let transforms = groupStack.compactMap(\.transform)

        let path = SVGPath(
            attributes: attributeDict,
            groupIDs: groupIDs,
            inheritedTransforms: transforms,
            fill: inheritedFill
        )

        parsedPaths.append(path)
    }

    func parser(
        _ parser: XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?
    ) {
        if ElementName.ignored.contains(elementName) {
            ignoredElementDepth = max(ignoredElementDepth - 1, 0)
        }

        guard elementName == ElementName.group else {
            return
        }

        _ = groupStack.popLast()
    }
}
