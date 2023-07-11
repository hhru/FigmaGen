#if canImport(FigmaGen)
import XCTest
@testable import FigmaGen

final class TokensResolverTests: XCTestCase {

    // MARK: - Instance Properties

    private let tokensResolver = DefaultTokensResolver()

    // MARK: - Instance Methods

    func testResolveValuesWithReferences() throws {
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

    func testResolveValuesWithoutReferences() throws {
        let numberValue = "10"
        let percentValue = "-2.50%"
        let textValue = "none"
        let pixelValue = "0px"
        let colorValue = "#ffffff"

        let actualNumberValue = try tokensResolver.resolveValue(numberValue, tokenValues: .empty)
        let actualPercentValue = try tokensResolver.resolveValue(percentValue, tokenValues: .empty)
        let actualTextValue = try tokensResolver.resolveValue(textValue, tokenValues: .empty)
        let actualPixelValue = try tokensResolver.resolveValue(pixelValue, tokenValues: .empty)
        let actualColorValue = try tokensResolver.resolveValue(colorValue, tokenValues: .empty)

        XCTAssertEqual(actualNumberValue, numberValue)
        XCTAssertEqual(actualPercentValue, percentValue)
        XCTAssertEqual(actualTextValue, textValue)
        XCTAssertEqual(actualPixelValue, pixelValue)
        XCTAssertEqual(actualColorValue, colorValue)
    }

    func testResolveRGBAColorWithReferences() throws {
        let tokenValues = TokenValues(
            core: [
                TokenValue(type: .opacity(value: "48%"), name: "core.opacity.48")
            ],
            semantic: [
                TokenValue(type: .opacity(value: "{core.opacity.48}"), name: "semantic.opacity.disabled")
            ],
            colors: [
                TokenValue(type: .core(value: "#ffffff"), name: "color.base.white")
            ],
            typography: [],
            day: [],
            night: []
        )

        let value = "rgba({color.base.white}, {semantic.opacity.disabled})"
        let expectedColor = Color(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.48)

        let actualColor = try tokensResolver.resolveRGBAColorValue(value, tokenValues: tokenValues)

        XCTAssertEqual(actualColor, expectedColor)
    }

    func testResolveRGBAColorWithoutReferences() throws {
        let value = "rgba(#FFFFFF, 48%)"
        let expectedColor = Color(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.48)

        let actualColor = try tokensResolver.resolveRGBAColorValue(value, tokenValues: .empty)

        XCTAssertEqual(actualColor, expectedColor)
    }

    func testResolveLinearGradientWithReferences() throws {
        let tokenValues = TokenValues(
            core: [
                TokenValue(type: .opacity(value: "0%"), name: "core.opacity.0")
            ],
            semantic: [
                TokenValue(type: .opacity(value: "{core.opacity.0}"), name: "semantic.opacity.transparent")
            ],
            colors: [
                TokenValue(type: .color(value: "#d64030"), name: "color.base.red.50")
            ],
            typography: [],
            day: [],
            night: []
        )

        let firstColor = "rgba({color.base.red.50}, {semantic.opacity.transparent})"
        let secondColor = "{color.base.red.50}"
        let value = "linear-gradient(0deg, \(firstColor) 0%, \(secondColor) 100%)"

        let expectedLinearGradient = LinearGradient(
            angle: "0deg",
            colorStopList: [
                LinearGradient.LinearColorStop(
                    color: Color(
                        red: 0.8392156862745098,
                        green: 0.25098039215686274,
                        blue: 0.18823529411764706,
                        alpha: 0.0
                    ),
                    percentage: "0%"
                ),
                LinearGradient.LinearColorStop(
                    color: Color(
                        red: 0.8392156862745098,
                        green: 0.25098039215686274,
                        blue: 0.18823529411764706,
                        alpha: 1.0
                    ),
                    percentage: "100%"
                )
            ]
        )

        let actualLinearGradient = try tokensResolver.resolveLinearGradientValue(
            value,
            tokenValues: tokenValues
        )

        XCTAssertEqual(actualLinearGradient, expectedLinearGradient)
    }

    func testResolveLinearGradientWithoutReferences() throws {
        let value = "linear-gradient(0deg, rgba(#d64030, 0%) 0%, #d64030 100%)"

        let expectedLinearGradient = LinearGradient(
            angle: "0deg",
            colorStopList: [
                LinearGradient.LinearColorStop(
                    color: Color(
                        red: 0.8392156862745098,
                        green: 0.25098039215686274,
                        blue: 0.18823529411764706,
                        alpha: 0.0
                    ),
                    percentage: "0%"
                ),
                LinearGradient.LinearColorStop(
                    color: Color(
                        red: 0.8392156862745098,
                        green: 0.25098039215686274,
                        blue: 0.18823529411764706,
                        alpha: 1.0
                    ),
                    percentage: "100%"
                )
            ]
        )

        let actualLinearGradient = try tokensResolver.resolveLinearGradientValue(
            value,
            tokenValues: .empty
        )

        XCTAssertEqual(actualLinearGradient, expectedLinearGradient)
    }
}

extension TokenValues {

    // MARK: - Type Properties

    static let empty = Self(
        core: [],
        semantic: [],
        colors: [],
        typography: [],
        day: [],
        night: []
    )
}
#endif
