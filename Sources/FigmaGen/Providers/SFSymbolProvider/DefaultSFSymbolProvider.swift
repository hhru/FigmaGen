import Foundation
import FigmaGenTools
import PromiseKit
import PathKit

final class DefaultSFSymbolProvider: SFSymbolProvider {

    // MARK: - Instance Properties

    private let dataProvider: DataProvider
    private let svgParser: SVGParser
    private let templateRenderer: TemplateRenderer

    // MARK: - Initializers

    init(dataProvider: DataProvider, svgParser: SVGParser, templateRenderer: TemplateRenderer) {
        self.dataProvider = dataProvider
        self.svgParser = svgParser
        self.templateRenderer = templateRenderer
    }

    // MARK: - Instance Methods

    func saveSymbol(
        from url: URL,
        to filePath: String,
        parameters: ImagesParameters
    ) -> Promise<Void> {
        firstly {
            self.dataProvider.fetchData(from: url)
        }.map(on: DispatchQueue.global(qos: .userInitiated)) { svgData in
            guard let templatePath = parameters.sfSymbolTemplate else {
                return
            }

            let filePath = Path(filePath)

            if filePath.exists {
                try filePath.delete()
            }

            let layerNames = parameters.symbolLayersName?
                .replacingOccurrences(of: " ", with: "")
                .components(separatedBy: ",") ?? []

            let symbol = try self.makeSymbol(
                from: self.svgParser.parse(data: svgData),
                filePath: filePath,
                layerNames: layerNames
            )

            try self.templateRenderer.renderTemplate(
                RenderTemplate(type: .custom(path: templatePath), options: [:]),
                to: .file(path: filePath.string),
                context: self.makeContext(for: symbol)
            )
        }
    }

    // MARK: -

    private func makeSymbol(from document: SVGDocument, filePath: Path, layerNames: [String]) throws -> SFSymbol {
        guard let canvas = document.canvas, canvas.width > 0.0, canvas.height > 0.0 else {
            throw SVGParserError.missingCanvasSize
        }

        guard !document.paths.isEmpty else {
            throw SVGParserError.invalidSVG
        }

        // Бокс компонента всегда занимает весь em дизайн-бокса, поэтому символ рисуется ровно
        // в том кегле, который передан в .font(.system(size:)).
        // Ширина сохраняет пропорции бокса компонента из Figma, чтобы заложенные дизайнером отступы
        // и неквадратные компоненты пережили конвертацию. Она округляется до целой дизайн-единицы,
        // потому что поля задают итоговый бокс символа, а дробное поле может расширить его на целую
        // единицу.
        let designHeight = SFSymbolGeometry.emDesignHeight
        let canvasScale = designHeight / canvas.height
        let designWidth = (canvas.width * canvasScale).rounded()

        // И Figma, и шаблон рисуют сверху вниз, поэтому переворот по Y не нужен - достаточно
        // масштаба и сдвига. Сдвиг ставит центр дизайн-бокса в центр cap height той строки,
        // в которую группа символа переносится шаблоном.
        let canvasToTemplate = SVGTransform
            .translation(x: 0.0, y: -SFSymbolGeometry.capHeight / 2.0 - designHeight / 2.0)
            .concatenating(.scale(x: canvasScale, y: canvasScale))

        return SFSymbol(
            name: filePath.lastComponentWithoutExtension,
            opticalWidth: canvas.width,
            opticalHeight: canvas.height,
            designWidth: designWidth,
            designHeight: designHeight,
            layers: try makeLayers(
                from: document.paths,
                canvasToTemplate: canvasToTemplate,
                layerNames: layerNames,
                filePath: filePath
            )
        )
    }

    private func makeLayers(
        from paths: [SVGPath],
        canvasToTemplate: SVGTransform,
        layerNames: [String],
        filePath: Path
    ) throws -> [SFSymbolLayer] {
        var layerRoles: [SFSymbolRole] = []
        var pathsByRole: [SFSymbolRole: [SFSymbolPath]] = [:]

        for path in paths {
            guard let pathData = path.data else {
                throw SVGParserError.invalidPathData("for \(filePath.string)")
            }

            let role = SFSymbolRole(of: path, layerNames: layerNames)

            if !layerRoles.contains(role) {
                layerRoles.append(role)
            }

            let pathTransform = canvasToTemplate.concatenating(
                try SVGTransformParser.transform(from: path.transformChain)
            )

            pathsByRole[role, default: []].append(
                SFSymbolPath(
                    data: try SVGPathTransformer(transform: pathTransform).transform(pathData: pathData),
                    fillRule: path.fillRule
                )
            )
        }

        return layerRoles.map { role in
            SFSymbolLayer(role: role, paths: pathsByRole[role] ?? [])
        }
    }

    private func makeContext(for symbol: SFSymbol) -> [String: Any] {
        let layers = symbol.layers.enumerated().map { index, layer -> [String: Any] in
            [
                "index": index,
                "role": layer.role.rawValue,
                // Motion-группы нумеруются от самого верхнего слоя - так их выгружает Xcode.
                "motionGroup": symbol.layers.count - 1 - index,
                "paths": layer.paths.map { path in
                    ["data": path.data, "fillRule": path.fillRule ?? ""]
                }
            ]
        }

        let variants = SFSymbolGeometry.scales.flatMap { scale in
            SFSymbolGeometry.weights.map { weight -> [String: Any] in
                // Округляется, чтобы оба поля попали на целые дизайн-единицы: центр колонки дробный,
                // и точное центрирование поставило бы поля на доли единицы.
                let originX = (weight.centerX - symbol.designWidth / 2.0).rounded()

                return [
                    "id": "\(weight.name)-\(scale.name)",
                    "originX": SVGNumber.string(from: originX),
                    "baseline": SVGNumber.string(from: scale.baseline),
                    "leftMargin": SVGNumber.string(from: originX),
                    "rightMargin": SVGNumber.string(from: originX + symbol.designWidth),
                    "guideTop": SVGNumber.string(from: scale.baseline - SFSymbolGeometry.marginGuideTopOffset),
                    "guideBottom": SVGNumber.string(from: scale.baseline + SFSymbolGeometry.marginGuideBottomOffset)
                ]
            }
        }

        return [
            "name": symbol.name,
            "opticalWidth": SVGNumber.string(from: symbol.opticalWidth),
            "opticalHeight": SVGNumber.string(from: symbol.opticalHeight),
            "designWidth": SVGNumber.string(from: symbol.designWidth),
            "designHeight": SVGNumber.string(from: symbol.designHeight),
            "layers": layers,
            "variants": variants
        ]
    }
}
