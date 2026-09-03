import Foundation
import FigmaGenTools
import PromiseKit
import PathKit

final class DefaultSFSymbolProvider: SFSymbolProvider {

    // MARK: - Instance Properties

    private let templateRenderer: TemplateRenderer

    private let svgParser: SVGParser
    private let dataCache = Cache<URL, Data>()

    init(svgParser: SVGParser, templateRenderer: TemplateRenderer) {
        self.svgParser = svgParser
        self.templateRenderer = templateRenderer
    }

    // MARK: - Instance Methods

    func saveData(from url: URL, to filePath: String, template: String?) -> Promise<Void> {
        firstly {
            self.fetchData(from: url)
        }.map(on: DispatchQueue.global(qos: .userInitiated)) { [weak self] fileData in
            guard let self, let template else {
                return
            }

            let filePath = Path(filePath)
            
            if filePath.exists {
                try filePath.delete()
            }

            let result = try self.svgParser.parse(id: filePath.string, data: fileData)

            let token = try extractPaths(from: result)

            try templateRenderer.renderTemplate(
                RenderTemplate(type: .custom(path: template), options: [:]),
                to: RenderDestination.file(path: filePath.string),
                context: makeContext(for: token)
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
final class DefaultSFSymbolProvider {

    // MARK: - Nested Types

    // Geometry of the SF Symbols template, matching the reference pipeline
    // described in Kolya/SF_SYMBOLS.md.
    private enum Geometry {

        // Typographic metrics shared by every row of the template. The cap height is 0.70459 of the
        // em, which matches the cap height of SF Pro and confirms that one em is 100 design units:
        // a design box of emDesignHeight units renders at exactly the point size of the font.
        static let capHeight = 70.459
        static let emDesignHeight = 100

        // The reported width of a symbol is the width of its rasterized artwork rounded up to a
        // whole device pixel. A design box of exactly emDesignHeight units lands on that boundary,
        // where the rounding goes either way, so the box is inset by a fraction of a unit. Half a
        // unit is a fifth of a device pixel at @3x and a point size of 24, which is invisible, and
        // it keeps the rounding on the low side.
        static let designBoxInset = 0.5

        // Vertical extent of the margin guides, relative to the baseline of their own row.
        static let marginGuideTopOffset = 95.215
        static let marginGuideBottomOffset = 24.121

        // Horizontal centers of the weight columns, taken from the labels
        // of the "Weight/Scale Variations" section of the template.
        static let weights: [(name: String, centerX: Double)] = [
            (name: "Ultralight", centerX: 559.711),
            (name: "Regular", centerX: 1449.845),
            (name: "Black", centerX: 2933.4)
        ]

        // Baselines of the scale rows. Every scale is authored explicitly and carries the same
        // drawing, so SF Symbols derives nothing and the image scale requested by the application
        // cannot change the rendered size.
        static let scales: [(name: String, baseline: Double)] = [
            (name: "S", baseline: 696.0),
            (name: "M", baseline: 1126.0),
            (name: "L", baseline: 1556.0)
        ]
    }

    private enum Fill {

        // Figma fills mapped to the secondary Palette layer. Black is mapped to the primary layer
        // by SVGParser, and any other fill fails generation.
        static let secondary: Set<String> = ["#ff0002"]
    }

    // MARK: - Instance Properties

    // teper ne nujno (est' parameter)
    //    private let templateRenderer = DefaultTemplateRenderer(
    //        contextCoder: DefaultTemplateContextCoder(),
    //        stencilExtensions: [
    //            StencilByteToHexFilter(),
    //            StencilHexToByteFilter(),
    //            StencilByteToFloatFilter(),
    //            StencilFloatToByteFilter(),
    //            StencilVectorInfoFilter(contextCoder: DefaultTemplateContextCoder()),
    //            StencilColorRGBHexInfoFilter(contextCoder: DefaultTemplateContextCoder()),
    //            StencilColorRGBAHexInfoFilter(contextCoder: DefaultTemplateContextCoder()),
    //            StencilColorRGBInfoFilter(contextCoder: DefaultTemplateContextCoder()),
    //            StencilColorRGBAInfoFilter(contextCoder: DefaultTemplateContextCoder()),
    //            StencilColorInfoFilter(contextCoder: DefaultTemplateContextCoder()),
    //            StencilFontInfoFilter(contextCoder: DefaultTemplateContextCoder()),
    //            StencilFontInitializerModificator(contextCoder: DefaultTemplateContextCoder()),
    //            StencilFontSystemFilter(contextCoder: DefaultTemplateContextCoder()),
    //            StencilCollectionDropFirstModificator(),
    //            StencilCollectionDropLastModificator(),
    //            StencilCollectionRemovingFirstModificator(),
    //            StencilHexToAlphaFilter(),
    //            StencilFullHexModificator(),
    //            StencilRecursiveTokenFindModicator()
    //        ]
    //    )

    // MARK: - Instance Methods

    private func resolveRole(of path: SVGPath) throws -> SFSymbolRole {
        if let id = path.id, let role = SFSymbolRole(rawValue: id.lowercased()) {
            return role
        }

        switch path.fill {
        case .black:
            return .primary

        case let .other(fill) where Fill.secondary.contains(normalizeFill(fill)):
            return .secondary

        case let .other(fill):
            throw SVGParserError.unsupportedFill(fill)

        case nil:
            throw SVGParserError.unsupportedFill("")
        }
    }

    private func normalizeFill(_ fill: String) -> String {
        fill
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .replacingOccurrences(of: " ", with: "")
    }

    private func extractPaths(from result: SVGPathsResult) throws -> SVGImageToken {
        guard let canvas = result.canvas, canvas.width > 0.0, canvas.height > 0.0 else {
            throw SVGParserError.missingCanvasSize
        }

        guard !result.allPaths.isEmpty else {
            throw SVGParserError.invalidSVG
        }

        // The component box fills the em design box, so the symbol renders at the point size given
        // to .font(.system(size:)). The optical size of the drawing is therefore chosen by that
        // point size and not baked into the geometry. The width keeps the proportions of the Figma
        // component box, so that intentional padding and non-square components survive.
        let designHeight = Geometry.emDesignHeight - Geometry.designBoxInset
        let designWidth = designHeight * canvas.width / canvas.height

        let pathData = try result.allPaths.map { path -> String in
            guard let data = path.data else {
                throw SVGParserError.invalidPathData("")
            }

            return data
        }

        // Figma clips the drawing to the component box, but the exported path data is not clipped
        // and regularly reaches a fraction of a point outside it. The reported symbol size follows
        // the artwork rather than the margin guides, so it is the union of the component box and
        // the artwork that has to fit the design box, not the component box alone.
        let sourceBox = try pathData
            .map { try SVGPathBounds.make(pathData: $0) }
            .reduce(SVGPathBounds(minX: 0.0, minY: 0.0, maxX: canvas.width, maxY: canvas.height)) {
                $0.union($1)
            }

        let scale = min(designWidth / sourceBox.width, designHeight / sourceBox.height)

        // Figma draws downwards from the top left corner, while the template draws upwards from the
        // baseline. The design box is centered on the cap height center, and the source box is
        // centered in the design box.
        let transformer = SVGPathTransformer(
            scale: scale,
            translationX: (designWidth - sourceBox.width * scale) / 2.0 - sourceBox.minX * scale,
            translationY: -Geometry.capHeight / 2.0 - designHeight / 2.0
                + (designHeight - sourceBox.height * scale) / 2.0
                - sourceBox.minY * scale
        )

        var roles: [SFSymbolRole] = []
        var pathsByRole: [SFSymbolRole: [SFSymbolPathData]] = [:]

        for (path, data) in zip(result.allPaths, pathData) {
            let role = try resolveRole(of: path)

            if !roles.contains(role) {
                roles.append(role)
            }

            pathsByRole[role, default: []].append(
                SFSymbolPathData(
                    data: try transformer.transform(pathData: data),
                    fillRule: path.fillRule
                )
            )
        }

        return SVGImageToken(
            name: URL(fileURLWithPath: result.id).deletingPathExtension().lastPathComponent,
            opticalSize: Int(canvas.height.rounded()),
            designWidth: designWidth,
            designHeight: designHeight,
            layers: roles.enumerated().map { index, role in
                SFSymbolLayer(index: index, role: role, paths: pathsByRole[role] ?? [])
            }
        )
    }

    private func makeContext(for token: SVGImageToken) -> [String: Any] {
        let layers = token.layers.map { layer -> [String: Any] in
            [
                "index": layer.index,
                "role": layer.role.rawValue,
                // Motion groups are numbered from the topmost layer, the way Xcode exports them.
                "motionGroup": token.layers.count - 1 - layer.index,
                "paths": layer.paths.map { path in
                    ["data": path.data, "fillRule": path.fillRule ?? ""]
                }
            ]
        }

        let variants = Geometry.scales.flatMap { scale in
            Geometry.weights.map { weight -> [String: Any] in
                // The guides sit exactly on the edges of the design box: they define the advance of
                // the symbol, and the artwork is fitted to the same box.
                let originX = weight.centerX - token.designWidth / 2.0

                return [
                    "id": "\(weight.name)-\(scale.name)",
                    "originX": SVGNumber.string(from: originX),
                    "baseline": SVGNumber.string(from: scale.baseline),
                    "leftMargin": SVGNumber.string(from: originX),
                    "rightMargin": SVGNumber.string(from: originX + token.designWidth),
                    "guideTop": SVGNumber.string(from: scale.baseline - Geometry.marginGuideTopOffset),
                    "guideBottom": SVGNumber.string(from: scale.baseline + Geometry.marginGuideBottomOffset)
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

    // MARK: - BorderTokensGenerator

    //    func generate(
    //        renderParameters: RenderParameters,
    //        tokenValues: TokenValues,
    //        result: SVGPathsResult,
    //        themes: [Theme],
    //        fallbackTheme: Theme
    //    ) throws {
    //        let token = try extractPaths(from: result)
    //
    //        try templateRenderer.renderTemplate(
    //            renderParameters.template,
    //            to: renderParameters.destination,
    //            context: makeContext(for: token)
    //        )
    //    }
}
