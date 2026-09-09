#if canImport(FigmaGen)
import XCTest
@testable import FigmaGen

final class DefaultSVGParserTests: XCTestCase {

    // MARK: - Instance Properties

    private let parser = DefaultSVGParser()

    // MARK: - Instance Methods

    private func parse(_ svg: String) throws -> SVGPathsResult {
        try parser.parse(id: "icon.svg", data: Data(svg.utf8))
    }

    // MARK: -

    func testGroupTransformsAreCollectedOuterToInner() throws {
        let result = try parse(
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
            result.allPaths.first?.allTransforms,
            ["translate(1 2)", "scale(2)", "rotate(90)"]
        )
    }

    func testGroupTransformReachesPathData() throws {
        let result = try parse(
            """
            <svg width="24" height="24">
              <g transform="translate(10 20)"><path d="M0 0 L1 0"/></g>
            </svg>
            """
        )

        let path = try XCTUnwrap(result.allPaths.first)
        let transformer = SVGPathTransformer(
            transform: try SVGTransformParser.transform(from: path.allTransforms)
        )

        XCTAssertEqual(try transformer.transform(pathData: XCTUnwrap(path.data)), "M10 20 L11 20")
    }

    func testGroupWithoutTransformIsSkipped() throws {
        let result = try parse(
            """
            <svg width="24" height="24">
              <g><g transform="translate(3 4)"><path d="M0 0"/></g></g>
            </svg>
            """
        )

        XCTAssertEqual(result.allPaths.first?.allTransforms, ["translate(3 4)"])
    }

    func testTransformsAreNotLeakedToSiblingGroups() throws {
        let result = try parse(
            """
            <svg width="24" height="24">
              <g transform="translate(1 0)"><path d="M0 0"/></g>
              <g><path d="M1 1"/></g>
            </svg>
            """
        )

        XCTAssertEqual(result.allPaths.count, 2)
        XCTAssertEqual(result.allPaths.first?.allTransforms, ["translate(1 0)"])
        XCTAssertEqual(result.allPaths.last?.allTransforms, [])
    }

    func testPathsInsideDefinitionsAreIgnored() throws {
        let result = try parse(
            """
            <svg width="24" height="24">
              <defs><path d="M9 9"/></defs>
              <path d="M0 0"/>
            </svg>
            """
        )

        XCTAssertEqual(result.allPaths.map(\.data), ["M0 0"])
    }

    func testCanvasFallsBackToViewBox() throws {
        let result = try parse(#"<svg viewBox="0 0 16 32"><path d="M0 0"/></svg>"#)

        XCTAssertEqual(result.canvas, SVGCanvas(width: 16.0, height: 32.0))
    }
}
#endif
