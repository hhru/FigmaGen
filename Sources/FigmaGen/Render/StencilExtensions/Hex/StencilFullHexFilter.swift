import Foundation

final class StencilFullHexFilter: StencilFilter {

    // MARK: - Instance Properties

    let name = "fullHex"

    // MARK: - Instance Methods

    func filter(input: String) throws -> String {
        guard input.hasPrefix("#") else {
            throw StencilFilterError(code: .invalidValue(input), filter: name)
        }

        let hex = input.uppercased()

        switch hex.count {
        case .rgb:
            return Array(hex)
                .map { "\($0)\($0)" }
                .joined()
                .appending("FF")

        case .rrggbb:
            return hex.appending("FF")

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
