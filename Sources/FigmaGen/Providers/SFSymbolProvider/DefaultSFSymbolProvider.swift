import Foundation
import FigmaGenTools
import PromiseKit
import PathKit

final class DefaultSFSymbolProvider: SFSymbolProvider {

    // MARK: - Instance Properties

    private let templateRenderer: TemplateRenderer

    private let svgParser: SVGParser
    private let dataCache = Cache<URL, Data>()
    private var symbolLayersName = [String]()

    init(svgParser: SVGParser, templateRenderer: TemplateRenderer) {
        self.svgParser = svgParser
        self.templateRenderer = templateRenderer
    }

    // MARK: - Instance Methods

    func saveData(
        from url: URL,
        to filePath: String,
        parameters: ImagesParameters
    ) -> Promise<Void> {
        firstly {
            self.fetchData(from: url)
        }.map(on: DispatchQueue.global(qos: .userInitiated)) { fileData in
            self.symbolLayersName = parameters
                .symbolLayersName?
                .replacingOccurrences(of: " ", with: "")
                .components(separatedBy: ",") ?? []

            guard let template = parameters.sfSymbolTemplate else {
                return
            }

            let filePath = Path(filePath)

            if filePath.exists {
                try filePath.delete()
            }

            let result = try self.svgParser.parse(id: filePath.string, data: fileData)

            let token = try self.extractPaths(from: result)

            try self.templateRenderer.renderTemplate(
                RenderTemplate(type: .custom(path: template), options: [:]),
                to: RenderDestination.file(path: filePath.string),
                context: self.makeContext(for: token)
            )
        }
    }

    // MARK: - Private methods

    private func fetchData(from url: URL) -> Promise<Data> {
        perform(on: DispatchQueue.global(qos: .userInitiated)) {
            if let data = self.dataCache.value(forKey: url) {
                return data
            }

            return try Data(contentsOf: url)
        }.get { data in
            self.dataCache.setValue(data, forKey: url)
        }
    }

    private func resolveRole(of path: SVGPath) -> SFSymbolRole {
        if let id = path.id, let role = SFSymbolRole(rawValue: id.lowercased()) {
            return role
        }

        return path.role(symbolLayersName: symbolLayersName)
    }

    private func extractPaths(from result: SVGPathsResult) throws -> SVGImageToken {
        guard let canvas = result.canvas, canvas.width > 0.0, canvas.height > 0.0 else {
            throw SVGParserError.missingCanvasSize
        }

        guard !result.allPaths.isEmpty else {
            throw SVGParserError.invalidSVG
        }

        // Бокс компонента всегда занимает весь em дизайн-бокса, поэтому символ рисуется ровно
        // в том кегле, который передан в .font(.system(size:)). Оптический размер рисунка задаётся
        // этим кеглем и не зашивается в геометрию.
        // Ширина сохраняет пропорции бокса компонента из Figma, чтобы заложенные дизайнером отступы
        // и неквадратные компоненты пережили конвертацию. Она округляется до целой дизайн-единицы,
        // потому что поля задают итоговый бокс символа, а дробное поле может расширить его на целую
        // единицу. Квадратный компонент и так целый, а у неквадратного в худшем случае правое поле
        // сдвинется на половину единицы, не задев сам рисунок.
        let designHeight = SFSymbolGeometry.emDesignHeight
        let scale = designHeight / canvas.height
        let designWidth = (canvas.width * scale).rounded()

        // И Figma, и шаблон рисуют сверху вниз, поэтому переворот по Y не нужен - достаточно
        // масштаба и сдвига. Сдвиг ставит центр дизайн-бокса в центр cap height той строки,
        // в которую группа символа переносится шаблоном.
        let baseTransform = SVGTransform(
            a: scale,
            b: 0.0,
            c: 0.0,
            d: scale,
            e: 0.0,
            f: -SFSymbolGeometry.capHeight / 2.0 - designHeight / 2.0
        )

        return SVGImageToken(
            name: URL(fileURLWithPath: result.id).deletingPathExtension().lastPathComponent,
            opticalSize: Int(canvas.height.rounded()),
            designWidth: designWidth,
            designHeight: designHeight,
            layers: try makeLayers(from: result, baseTransform: baseTransform)
        )
    }

    /// Раскладывает пути по ролям, сохраняя порядок появления ролей в файле:
    /// он определяет номера слоёв и motion-групп в шаблоне.
    private func makeLayers(from result: SVGPathsResult, baseTransform: SVGTransform) throws -> [SFSymbolLayer] {
        var roles: [SFSymbolRole] = []
        var pathsByRole: [SFSymbolRole: [SFSymbolPathData]] = [:]

        for path in result.allPaths {
            guard let data = path.data else {
                throw SVGParserError.invalidPathData("for \(result.id)")
            }

            let role = resolveRole(of: path)

            if !roles.contains(role) {
                roles.append(role)
            }

            // Собственный и унаследованный transform пути применяются к его координатам
            // до перевода в пространство шаблона, поэтому базовое преобразование идёт первым.
            let transformer = SVGPathTransformer(
                transform: baseTransform.concatenating(try SVGTransformParser.transform(from: path.allTransforms))
            )

            pathsByRole[role, default: []].append(
                SFSymbolPathData(
                    data: try transformer.transform(pathData: data),
                    fillRule: path.fillRule
                )
            )
        }

        return roles.enumerated().map { index, role in
            SFSymbolLayer(index: index, role: role, paths: pathsByRole[role] ?? [])
        }
    }

    private func makeContext(for token: SVGImageToken) -> [String: Any] {
        let layers = token.layers.map { layer -> [String: Any] in
            [
                "index": layer.index,
                "role": layer.role.rawValue,
                // Motion-группы нумеруются от самого верхнего слоя - так их выгружает Xcode.
                "motionGroup": token.layers.count - 1 - layer.index,
                "paths": layer.paths.map { path in
                    ["data": path.data, "fillRule": path.fillRule ?? ""]
                }
            ]
        }

        let variants = SFSymbolGeometry.scales.flatMap { scale in
            SFSymbolGeometry.weights.map { weight -> [String: Any] in
                // Округляется, чтобы оба поля попали на целые дизайн-единицы: центр колонки дробный,
                // и точное центрирование поставило бы поля на доли единицы.
                let originX = (weight.centerX - token.designWidth / 2.0).rounded()

                return [
                    "id": "\(weight.name)-\(scale.name)",
                    "originX": SVGNumber.string(from: originX),
                    "baseline": SVGNumber.string(from: scale.baseline),
                    "leftMargin": SVGNumber.string(from: originX),
                    "rightMargin": SVGNumber.string(from: originX + token.designWidth),
                    "guideTop": SVGNumber.string(from: scale.baseline - SFSymbolGeometry.marginGuideTopOffset),
                    "guideBottom": SVGNumber.string(from: scale.baseline + SFSymbolGeometry.marginGuideBottomOffset)
                ]
            }
        }

        return [
            "name": token.name,
            "opticalSize": token.opticalSize,
            "designWidth": SVGNumber.string(from: token.designWidth),
            "designHeight": SVGNumber.string(from: token.designHeight),
            "layers": layers,
            "variants": variants
        ]
    }
}

extension SVGPath {

    func role(symbolLayersName: [String]) -> SFSymbolRole {
        let primaryLayerName: String = symbolLayersName.first ?? ""
        let secondaryLayerName: String = symbolLayersName.dropFirst().first ?? ""
        let tertiaryLayerName: String = symbolLayersName.dropFirst(2).first ?? ""

        if
            id == "secondary"
                || symbolLayersName.isEmpty && fill == .black
                || wholeID.contains(primaryLayerName)  {
            return .primary
        }

        if
            id == "secondary"
                || symbolLayersName.isEmpty && fill != .black
                || wholeID.contains(secondaryLayerName)  {
            return .secondary
        }

        if id == "tertiary" || wholeID.contains(tertiaryLayerName)  {
            return .tertiary
        }

        return .tertiary
    }
}
