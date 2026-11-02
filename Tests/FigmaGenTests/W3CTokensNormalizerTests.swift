#if canImport(FigmaGen)
import XCTest
@testable import FigmaGen

final class W3CTokensNormalizerTests: XCTestCase {

    // MARK: - Instance Properties

    private var warnings: [String] = []
    private lazy var normalizer = W3CTokensNormalizer { [unowned self] in warnings.append($0) }

    // MARK: - Instance Methods

    private func makeManifest(themes: [String] = ["hh-day"]) throws -> SXLTokensManifest {
        func collection(_ name: String, modes: [(name: String, file: String)]) -> String {
            let modes = modes
                .map { #"{"name": "\#($0.name)", "enabled": true, "files": {"\#($0.file)": "enabled"}}"# }
                .joined(separator: ", ")

            return #"{"name": "\#(name)", "enabled": true, "modes": [\#(modes)]}"#
        }

        let collections = [
            collection("palette", modes: [("default", "palette.json")]),
            collection("core", modes: [("default", "core.json")]),
            collection("common", modes: [("default", "common.json")]),
            collection("typography", modes: [("default", "typography.json")]),
            collection("themes", modes: themes.map { ($0, "themes/\($0).json") })
        ]

        let json = #"{"$schema": "\#(SXLTokensManifest.schema)", "collections": [\#(collections.joined(separator: ", "))]}"#

        return try JSONDecoder().decode(SXLTokensManifest.self, from: Data(json.utf8))
    }

    private func decode(_ json: String) throws -> W3CTokenJSON {
        try JSONDecoder().decode(W3CTokenJSON.self, from: Data(json.utf8))
    }

    private func normalize(core: String = "{}", common: String = "{}", theme: String = "{}") throws -> TokenValues {
        try normalizer.normalize(
            manifest: makeManifest(),
            files: [
                "palette.json": decode(##"{"color": {"base": {"white": {"$value": "#ffffff", "$type": "color"}}}}"##),
                "core.json": decode(core),
                "common.json": decode(common),
                "typography.json": decode("{}"),
                "themes/hh-day.json": decode(theme)
            ],
            mapping: W3CTokenSetsMapping()
        )
    }

    private func tokenType(_ name: String, in tokens: [TokenValue]) -> TokenValueType? {
        tokens.first { $0.name == name }?.type
    }

    func testSetsMappingAndNames() throws {
        let tokenValues = try normalize(
            core: #"{"core": {"space": {"1-x": {"$value": "{core.x-base} * 2", "$type": "spacing"}}}}"#,
            theme: #"{"color": {"text": {"primary": {"$value": "{color.base.white}", "$type": "color"}}}}"#
        )

        XCTAssertEqual(tokenValues.colors, [TokenValue(type: .color(value: "#ffffff"), name: "color.base.white")])
        XCTAssertEqual(
            tokenValues.core,
            [TokenValue(type: .spacing(value: "{core.x-base} * 2"), name: "core.space.1-x")]
        )
        XCTAssertEqual(
            tokenValues.tokens(for: Theme("hh-day")),
            [TokenValue(type: .color(value: "{color.base.white}"), name: "color.text.primary")]
        )
    }

    func testRenamedTypesAndNumbers() throws {
        let tokenValues = try normalize(
            core: """
                {"core": {
                    "fontSize": {"100": {"$value": "4", "$type": "fontSize"}},
                    "lineHeights": {"100": {"$value": "4", "$type": "lineHeight"}},
                    "x-base": {"$value": 2, "$type": "number"},
                    "scale": {"2": {"$value": 0.96, "$type": "number"}}
                }}
                """
        )

        XCTAssertEqual(tokenType("core.fontSize.100", in: tokenValues.core), .fontSizes(value: "4"))
        XCTAssertEqual(tokenType("core.lineHeights.100", in: tokenValues.core), .lineHeights(value: "4"))
        XCTAssertEqual(tokenType("core.x-base", in: tokenValues.core), .core(value: "2.0"))
        XCTAssertEqual(tokenType("core.scale.2", in: tokenValues.core), .core(value: "0.96"))
    }

    func testAnimations() throws {
        let tokenValues = try normalize(
            common: """
                {"semantic": {"animation": {
                    "time": {"xs": {"$value": "100ms", "$type": "duration"}},
                    "ease": {
                        "base": {"$value": [0.4, 0.24, 0, 1], "$type": "cubicBezier"},
                        "spring": {"$value": "spring(1, 400, 30, 0)", "$type": "easing"}
                    },
                    "ease-in-out-100": {
                        "$value": {"duration": "100ms", "delay": "0ms", "easing": "cubic-bezier(0.25, 0.1, 0.25, 1)"},
                        "$type": "transition"
                    }
                }}}
                """
        )

        XCTAssertEqual(
            tokenType("semantic.animation.time.xs", in: tokenValues.semantic),
            .animationTime(value: TokenAnimationTimeValue(duration: "100"))
        )
        XCTAssertEqual(
            tokenType("semantic.animation.ease.base", in: tokenValues.semantic),
            .animationEaseBase(value: TokenAnimationEaseBaseValue(x1: "0.4", y1: "0.24", x2: "0.0", y2: "1.0"))
        )
        XCTAssertEqual(
            tokenType("semantic.animation.ease.spring", in: tokenValues.semantic),
            .animationEaseSpring(value: TokenAnimationEaseSpringValue(
                stiffness: "400",
                damping: "30",
                mass: "1",
                velocity: "0"
            ))
        )
        XCTAssertEqual(
            tokenType("semantic.animation.ease-in-out-100", in: tokenValues.semantic),
            .animation(value: TokenAnimationValue(
                x1: "0.25",
                y1: "0.1",
                x2: "0.25",
                y2: "1",
                duration: "100",
                delay: "0"
            ))
        )
    }

    func testShadow() throws {
        let tokenValues = try normalize(
            theme: """
                {"shadow": {"level-1": {
                    "$value": {
                        "offsetX": "0", "offsetY": "4", "blur": "12", "spread": "0",
                        "color": "#7090b029", "type": "dropShadow"
                    },
                    "$type": "shadow"
                }}}
                """
        )

        XCTAssertEqual(
            tokenType("shadow.level-1", in: tokenValues.tokens(for: Theme("hh-day"))),
            .boxShadow(
                value: TokenBoxShadowValue(
                    color: "#7090b029",
                    type: "dropShadow",
                    x: "0",
                    y: "4",
                    blur: "12",
                    spread: "0"
                )
            )
        )
    }

    func testGroupTypeInheritanceAndUnknownTypes() throws {
        let tokenValues = try normalize(
            core: """
                {"core": {
                    "space": {"$type": "spacing", "1-x": {"$value": "4"}},
                    "unknown": {"$value": "value", "$type": "fontStyle"}
                }}
                """
        )

        XCTAssertEqual(tokenValues.core, [TokenValue(type: .spacing(value: "4"), name: "core.space.1-x")])
        XCTAssertEqual(warnings.count, 1)
    }

    func testDescription() throws {
        let tokenValues = try normalize(
            theme: ##"{"color": {"text": {"$value": "#000000", "$type": "color", "$description": "DEPRECATED"}}}"##
        )

        XCTAssertEqual(tokenValues.tokens(for: Theme("hh-day")).first?.description, "DEPRECATED")
    }

    func testMissingCollectionThrows() {
        let manifest = SXLTokensManifest(schema: SXLTokensManifest.schema, collections: [])

        XCTAssertThrowsError(try normalizer.normalize(manifest: manifest, files: [:], mapping: W3CTokenSetsMapping()))
    }
}
#endif
