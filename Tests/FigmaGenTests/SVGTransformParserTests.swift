#if canImport(FigmaGen)
import XCTest
@testable import FigmaGen

final class SVGTransformParserTests: XCTestCase {

    // MARK: - Instance Methods

    private func assertEqual(
        _ transform: SVGTransform,
        _ expected: SVGTransform,
        line: UInt = #line
    ) {
        let components = [
            (transform.a, expected.a),
            (transform.b, expected.b),
            (transform.c, expected.c),
            (transform.d, expected.d),
            (transform.e, expected.e),
            (transform.f, expected.f)
        ]

        components.forEach { actual, expected in
            XCTAssertEqual(actual, expected, accuracy: 1e-9, line: line)
        }
    }

    // MARK: -

    func testEmptyValueIsIdentity() throws {
        assertEqual(try SVGTransformParser.transform(from: ""), .identity)
        assertEqual(try SVGTransformParser.transform(from: []), .identity)
    }

    func testMatrix() throws {
        assertEqual(
            try SVGTransformParser.transform(from: "matrix(1 2 3 4 5 6)"),
            SVGTransform(a: 1.0, b: 2.0, c: 3.0, d: 4.0, e: 5.0, f: 6.0)
        )
    }

    func testTranslateWithOmittedY() throws {
        assertEqual(try SVGTransformParser.transform(from: "translate(5)"), .translation(x: 5.0, y: 0.0))
    }

    func testScaleWithOmittedYIsUniform() throws {
        assertEqual(try SVGTransformParser.transform(from: "scale(3)"), .scale(x: 3.0, y: 3.0))
    }

    func testCommaAndWhitespaceSeparators() throws {
        assertEqual(
            try SVGTransformParser.transform(from: "translate( 1 , 2 )"),
            .translation(x: 1.0, y: 2.0)
        )
    }

    func testRotateAroundCenter() throws {
        // Поворот на 180° вокруг (10, 0) переводит начало координат в (20, 0).
        let transform = try SVGTransformParser.transform(from: "rotate(180 10 0)")
        let point = transform.apply(x: 0.0, y: 0.0)

        XCTAssertEqual(point.x, 20.0, accuracy: 1e-9)
        XCTAssertEqual(point.y, 0.0, accuracy: 1e-9)
    }

    func testTransformListIsAppliedOuterToInner() throws {
        // Списку "translate scale" соответствует произведение в том же порядке.
        assertEqual(
            try SVGTransformParser.transform(from: "translate(10 0) scale(2)"),
            SVGTransform(a: 2.0, b: 0.0, c: 0.0, d: 2.0, e: 10.0, f: 0.0)
        )
    }

    func testGroupChainIsAppliedOuterToInner() throws {
        assertEqual(
            try SVGTransformParser.transform(from: ["translate(10 0)", "scale(2)"]),
            SVGTransform(a: 2.0, b: 0.0, c: 0.0, d: 2.0, e: 10.0, f: 0.0)
        )
    }

    func testSimilarityDetection() throws {
        XCTAssertTrue(try SVGTransformParser.transform(from: "rotate(30) scale(2)").isSimilarity)
        XCTAssertTrue(try SVGTransformParser.transform(from: "scale(-2 2)").isSimilarity)
        XCTAssertFalse(try SVGTransformParser.transform(from: "scale(1 2)").isSimilarity)
        XCTAssertFalse(try SVGTransformParser.transform(from: "skewX(20)").isSimilarity)
    }

    func testUnknownFunctionIsRejected() throws {
        XCTAssertThrowsError(try SVGTransformParser.transform(from: "warp(1 2)"))
    }

    func testWrongParameterCountIsRejected() throws {
        XCTAssertThrowsError(try SVGTransformParser.transform(from: "matrix(1 2 3)"))
        XCTAssertThrowsError(try SVGTransformParser.transform(from: "rotate(1 2)"))
    }

    func testMalformedValueIsRejected() throws {
        XCTAssertThrowsError(try SVGTransformParser.transform(from: "translate(1 2"))
        XCTAssertThrowsError(try SVGTransformParser.transform(from: "translate(1 2) garbage"))
    }
}
#endif
