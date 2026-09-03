import Foundation

final class SFSymbolProvider {

    // MARK: - Nested Types

    // Geometry of the SF Symbols template, matching the reference pipeline
    // described in Kolya/SF_SYMBOLS.md.
    private enum Geometry {

        // Typographic metrics shared by every row of the template. The cap height is 0.70459 of the
        // em, which matches the cap height of SF Pro and confirms that one em is 100 design units:
        // a design box of emDesignHeight units renders at exactly the point size of the font.
        static let capHeight = 70.459
        static let emDesignHeight = 99.5 // 100.0

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

    private let templateRenderer = DefaultTemplateRenderer(
        contextCoder: DefaultTemplateContextCoder(),
        stencilExtensions: [
            StencilByteToHexFilter(),
            StencilHexToByteFilter(),
            StencilByteToFloatFilter(),
            StencilFloatToByteFilter(),
            StencilVectorInfoFilter(contextCoder: DefaultTemplateContextCoder()),
            StencilColorRGBHexInfoFilter(contextCoder: DefaultTemplateContextCoder()),
            StencilColorRGBAHexInfoFilter(contextCoder: DefaultTemplateContextCoder()),
            StencilColorRGBInfoFilter(contextCoder: DefaultTemplateContextCoder()),
            StencilColorRGBAInfoFilter(contextCoder: DefaultTemplateContextCoder()),
            StencilColorInfoFilter(contextCoder: DefaultTemplateContextCoder()),
            StencilFontInfoFilter(contextCoder: DefaultTemplateContextCoder()),
            StencilFontInitializerModificator(contextCoder: DefaultTemplateContextCoder()),
            StencilFontSystemFilter(contextCoder: DefaultTemplateContextCoder()),
            StencilCollectionDropFirstModificator(),
            StencilCollectionDropLastModificator(),
            StencilCollectionRemovingFirstModificator(),
            StencilHexToAlphaFilter(),
            StencilFullHexModificator(),
            StencilRecursiveTokenFindModicator()
        ]
    )

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

        // The component box always fills the em design box, so the symbol renders at exactly the
        // point size given to .font(.system(size:)). The optical size of the drawing is therefore
        // chosen by that point size and not baked into the geometry.
        // The width keeps the proportions of the Figma component box, so that intentional padding
        // and non-square components survive the conversion. It is rounded to a whole design unit
        // because the margin guides define the reported symbol box and a fractional guide can widen
        // that box by a whole unit. A square component is already integral, and the worst case for
        // a non-square one moves the right guide by half a unit without touching the artwork.
        let designHeight = Geometry.emDesignHeight
        let scale = designHeight / canvas.height
        let designWidth = (canvas.width * scale).rounded()

        // Figma draws downwards from the top left corner of the component box, while the template
        // draws upwards from the baseline. The box is centered on the cap height center.
        let transformer = SVGPathTransformer(
            scale: scale,
            translationY: -Geometry.capHeight / 2.0 - designHeight / 2.0
        )

        var roles: [SFSymbolRole] = []
        var pathsByRole: [SFSymbolRole: [SFSymbolPathData]] = [:]

        for path in result.allPaths {
            guard let data = path.data else {
                throw SVGParserError.invalidPathData("")
            }

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
                // Rounded so that both margin guides land on whole design units. The column center
                // is fractional, so centering exactly would put the guides on fractions of a unit.
                let originX = (weight.centerX - token.designWidth / 2.0).rounded()

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

    func generate(
        renderParameters: RenderParameters,
        tokenValues: TokenValues,
        result: SVGPathsResult,
        themes: [Theme],
        fallbackTheme: Theme
    ) throws {
        let token = try extractPaths(from: result)

        try templateRenderer.renderTemplate(
            renderParameters.template,
            to: renderParameters.destination,
            context: makeContext(for: token)
        )
    }
}
