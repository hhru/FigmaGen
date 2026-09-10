#if canImport(FigmaGen)
import XCTest
@testable import FigmaGen

final class DefaultSVGParserTests: XCTestCase {

    // MARK: - Instance Properties

    private let parser = DefaultSVGParser()

    // MARK: - Instance Methods

    private func parse(_ svg: String) throws -> SVGDocument {
        try parser.parse(data: Data(svg.utf8))
    }

    // MARK: -

    func testGroupTransformsAreCollectedOuterToInner() throws {
        let document = try parse(
            """
            <svg width="24" height="24">
              <g transform="translate(1 2)">
                <g transform="scale(2)">
                  <path d="M0 0" transform="rotate(90)"/>
                </g>
              </g>
            </svg>
            """
        )

        XCTAssertEqual(
            document.paths.first?.transformChain,
            ["translate(1 2)", "scale(2)", "rotate(90)"]
        )
    }

    func testGroupTransformReachesPathData() throws {
        let document = try parse(
            """
            <svg width="24" height="24">
              <g transform="translate(10 20)"><path d="M0 0 L1 0"/></g>
            </svg>
            """
        )

        let path = try XCTUnwrap(document.paths.first)
        let transformer = SVGPathTransformer(
            transform: try SVGTransformParser.transform(from: path.transformChain)
        )

        XCTAssertEqual(try transformer.transform(pathData: XCTUnwrap(path.data)), "M10 20 L11 20")
    }

    func testGroupWithoutTransformIsSkipped() throws {
        let document = try parse(
            """
            <svg width="24" height="24">
              <g><g transform="translate(3 4)"><path d="M0 0"/></g></g>
            </svg>
            """
        )

        XCTAssertEqual(document.paths.first?.transformChain, ["translate(3 4)"])
    }

    func testTransformsAreNotLeakedToSiblingGroups() throws {
        let document = try parse(
            """
            <svg width="24" height="24">
              <g transform="translate(1 0)"><path d="M0 0"/></g>
              <g><path d="M1 1"/></g>
            </svg>
            """
        )

        XCTAssertEqual(document.paths.count, 2)
        XCTAssertEqual(document.paths.first?.transformChain, ["translate(1 0)"])
        XCTAssertEqual(document.paths.last?.transformChain, [])
    }

    func testGroupIDsAndFillAreInherited() throws {
        let document = try parse(
            """
            <svg width="24" height="24">
              <g id="Icon" fill="#000"><g id="Primary"><path id="Vector" d="M0 0"/></g></g>
              <g id="Secondary" style="fill: #FF0002"><path d="M1 1"/></g>
            </svg>
            """
        )

        XCTAssertEqual(document.paths.first?.idChain, "Icon;Primary;Vector")
        XCTAssertEqual(document.paths.first?.fill, .black)
        XCTAssertEqual(document.paths.last?.idChain, "Secondary")
        XCTAssertEqual(document.paths.last?.fill, .other("#FF0002"))
    }

    func testPathsInsideDefinitionsAreIgnored() throws {
        let document = try parse(
            """
            <svg width="24" height="24">
              <defs><path d="M9 9"/></defs>
              <path d="M0 0"/>
            </svg>
            """
        )

        XCTAssertEqual(document.paths.map(\.data), ["M0 0"])
    }

    func testCanvasFallsBackToViewBox() throws {
        let document = try parse(#"<svg viewBox="0 0 16 32"><path d="M0 0"/></svg>"#)

        XCTAssertEqual(document.canvas, SVGCanvas(width: 16.0, height: 32.0))
    }
}
#endif
