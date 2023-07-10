import XCTest
@testable import FigmaGen

final class TokensResolverTests: XCTestCase {

    // MARK: - Instance Properties

    private let tokensResolver = DefaultTokensResolver()

    // MARK: - Instance Methods

    func testResolveValues() throws {
        let tokenValues = TokenValues(
            core: [
                TokenValue(type: .core(value: "2"), name: "core.x-base"), // 2
                TokenValue(type: .core(value: "{core.x-base} * 2"), name: "core.2-x-base"), // 4
                TokenValue(type: .spacing(value: "{core.2-x-base} * 1"), name: "core.space.1-x") // 4
            ],
            semantic: [],
            colors: [],
            typography: [],
            day: [],
            night: []
        )

        let value = "{core.space.1-x} + {core.space.1-x} / 2"
        let expectedValue = "6"

        let actualValue = try tokensResolver.resolveValue(value, tokenValues: tokenValues)

        XCTAssertEqual(actualValue, expectedValue)
    }
}
