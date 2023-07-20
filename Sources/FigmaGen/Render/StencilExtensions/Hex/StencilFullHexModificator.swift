import Foundation

final class StencilFullHexModificator: StencilModificator {

    // MARK: - Nested Types

    fileprivate enum AlphaHexPosition: String {

        // MARK: - Enumeration Cases

        case start
        case end
    }

    // MARK: - Instance Properties

    let name = "fullHex"

    // MARK: - Instance Methods

    func modify(input: String, withArguments arguments: [Any?]) throws -> String {
        let hexPosition = arguments
            .first
            .flatMap { $0 as? String }
            .flatMap { AlphaHexPosition(rawValue: $0) } ?? .end

        guard input.hasPrefix("#") else {
            throw StencilFilterError(code: .invalidValue(input), filter: name)
        }

        let hex = input.uppercased()

        switch hex.count {
        case .rgb:
            return Array(hex)
                .map { "\($0)\($0)" }
                .joined()
                .appendingHexAlpha(to: hexPosition)

        case .rrggbb:
            return hex.appendingHexAlpha(to: hexPosition)

        case .rrggbbaa:
            return hex

        default:
            throw StencilFilterError(code: .invalidValue(input), filter: name)
        }
    }
}

extension Int {

    // MARK: - Type Properties

    fileprivate static let rgb = 4
    fileprivate static let rrggbb = 7
    fileprivate static let rrggbbaa = 9
}

extension String {

    // MARK: - Instance Methods

    fileprivate func appendingHexAlpha(to position: StencilFullHexModificator.AlphaHexPosition) -> Self {
        let alphaHex = "FF"

        switch position {
        case .start:
            return alphaHex + self

        case .end:
            return self + alphaHex
        }
    }
}
