#if canImport(FigmaGen)
import XCTest
@testable import FigmaGen

final class SVGPathTransformerTests: XCTestCase {

    // MARK: - Instance Methods

    private func transform(_ pathData: String, by transform: SVGTransform) throws -> String {
        try SVGPathTransformer(transform: transform).transform(pathData: pathData)
    }

    private func transform(_ pathData: String, by attribute: String) throws -> String {
        try transform(pathData, by: SVGTransformParser.transform(from: attribute))
    }

    // MARK: -

    func testIdentityNormalizesToAbsoluteCommands() throws {
        // Относительные команды и h/v разворачиваются в абсолютные L.
        XCTAssertEqual(
            try transform("m10 10 l5 0 v5 h-5 z", by: .identity),
            "M10 10 L15 10 L15 15 L10 15 Z"
        )
    }

    func testImplicitCommandRepetition() throws {
        // Повторные группы после moveto - это lineto, а не ещё один moveto.
        XCTAssertEqual(
            try transform("M0 0 1 1 2 2", by: .identity),
            "M0 0 L1 1 L2 2"
        )

        // Повторные группы обычных команд сохраняют свою команду.
        XCTAssertEqual(
            try transform("M0 0 L1 1 2 2", by: .identity),
            "M0 0 L1 1 L2 2"
        )
    }

    func testRelativeCommandsAfterClosePath() throws {
        // После z текущей точкой становится начало контура.
        XCTAssertEqual(
            try transform("M10 10 L20 10 Z l0 5", by: .identity),
            "M10 10 L20 10 Z L10 15"
        )
    }

    func testTranslationIsApplied() throws {
        XCTAssertEqual(
            try transform("M0 0 L10 0", by: "translate(5 7)"),
            "M5 7 L15 7"
        )
    }

    func testNestedTransformsAreAppliedOuterToInner() throws {
        // translate(10 0) применяется к результату scale(2), а не наоборот.
        XCTAssertEqual(
            try transform("M1 0", by: "translate(10 0) scale(2)"),
            "M12 0"
        )
    }

    func testRotationTurnsAxisAlignedSegmentsIntoDiagonals() throws {
        // Ровно тот случай, ради которого h/v переводятся в L.
        XCTAssertEqual(
            try transform("M0 0 h10", by: "rotate(90)"),
            "M0 0 L0 10"
        )
    }

    func testRelativeOffsetsIgnoreTranslationPart() throws {
        // У относительной команды переносится только линейная часть преобразования.
        XCTAssertEqual(
            try transform("M0 0 l10 0", by: "translate(100 100) scale(2)"),
            "M100 100 L120 100"
        )
    }

    func testCurveControlPointsAreTransformed() throws {
        XCTAssertEqual(
            try transform("M0 0 c1 1 2 2 3 3", by: "scale(2)"),
            "M0 0 C2 2 4 4 6 6"
        )
    }

    func testArcUnderSimilarityScalesRadii() throws {
        XCTAssertEqual(
            try transform("M0 0 A5 5 0 1 0 10 0", by: "scale(2)"),
            "M0 0 A10 10 0 1 0 20 0"
        )
    }

    func testArcUnderMirroringFlipsSweepFlag() throws {
        XCTAssertEqual(
            try transform("M0 0 A5 5 0 1 0 10 0", by: "scale(-1 1)"),
            "M0 0 A5 5 0 1 1 -10 0"
        )
    }

    func testArcUnderMirroringReflectsEllipseRotation() throws {
        // Отражение относительно оси Y переводит наклон +30° в +150°.
        XCTAssertEqual(
            try transform("M0 0 A10 5 30 0 1 10 0", by: "scale(-1 1)"),
            "M0 0 A10 5 150 0 0 -10 0"
        )
    }

    func testArcUnderRotationAddsEllipseRotation() throws {
        XCTAssertEqual(
            try transform("M0 0 A10 5 20 0 1 10 0", by: "rotate(40)"),
            "M0 0 A10 5 60 0 1 7.660444 6.427876"
        )
    }

    func testArcUnderNonSimilarityIsRejected() throws {
        // Неравномерный масштаб превращает окружность в эллипс с другими радиусами -
        // такое молча пересчитывать нельзя.
        XCTAssertThrowsError(try transform("M0 0 A5 5 0 1 0 10 0", by: "scale(1 2)")) { error in
            guard case SVGParserError.unsupportedArcTransform = error else {
                return XCTFail("Ожидалась ошибка unsupportedArcTransform, получено \(error)")
            }
        }
    }

    func testNonSimilarityIsAllowedWithoutArcs() throws {
        XCTAssertEqual(
            try transform("M1 1 L2 2", by: "scale(1 2)"),
            "M1 2 L2 4"
        )
    }

    func testTrailingGarbageIsRejected() throws {
        // Раньше неразобранный хвост молча отбрасывался вместе с частью рисунка.
        XCTAssertThrowsError(try transform("M0 0 L10 10 ?!", by: .identity))
    }

    func testUnknownCommandIsRejected() throws {
        XCTAssertThrowsError(try transform("M0 0 X10 10", by: .identity))
    }

    func testMissingParametersAreRejected() throws {
        XCTAssertThrowsError(try transform("M0 0 L10", by: .identity))
    }

    func testEmptyPathDataIsRejected() throws {
        XCTAssertThrowsError(try transform("", by: .identity))
    }
}
#endif
