#if canImport(FigmaGen)
import XCTest
@testable import FigmaGen

final class SFSymbolRoleTests: XCTestCase {

    // MARK: - Instance Methods

    private func makePath(id: String? = nil, fill: SVGColor? = nil, groupIDs: [String] = []) -> SVGPath {
        SVGPath(
            id: id,
            data: "M0 0",
            fillRule: nil,
            fill: fill,
            transform: nil,
            groupIDs: groupIDs,
            groupTransforms: []
        )
    }

    // MARK: -

    func testOwnIDNamesRole() {
        XCTAssertEqual(SFSymbolRole(of: makePath(id: "Secondary", fill: .black), layerNames: []), .secondary)
        XCTAssertEqual(SFSymbolRole(of: makePath(id: "tertiary"), layerNames: ["tertiary"]), .tertiary)
    }

    func testWithoutLayerNamesRoleFollowsFill() {
        XCTAssertEqual(SFSymbolRole(of: makePath(fill: .black), layerNames: []), .primary)
        XCTAssertEqual(SFSymbolRole(of: makePath(fill: .other("#FF0002")), layerNames: []), .secondary)
        XCTAssertEqual(SFSymbolRole(of: makePath(fill: nil), layerNames: []), .secondary)
    }

    func testLayerNamesAreMatchedAgainstGroupIDs() {
        let layerNames = ["Front", "Back", "Shadow"]

        XCTAssertEqual(SFSymbolRole(of: makePath(groupIDs: ["Icon", "Front"]), layerNames: layerNames), .primary)
        XCTAssertEqual(SFSymbolRole(of: makePath(groupIDs: ["Icon", "Back"]), layerNames: layerNames), .secondary)
        XCTAssertEqual(SFSymbolRole(of: makePath(groupIDs: ["Icon", "Shadow"]), layerNames: layerNames), .tertiary)
        XCTAssertEqual(SFSymbolRole(of: makePath(fill: .black, groupIDs: ["Icon"]), layerNames: layerNames), .tertiary)
    }

    func testMissingSecondaryLayerNameLeavesOtherPathsTertiary() {
        XCTAssertEqual(SFSymbolRole(of: makePath(groupIDs: ["Back"]), layerNames: ["Front"]), .tertiary)
    }
}
#endif
