import Foundation

final class StencilHexToAlphaFilter: StencilFilter {

    // MARK: - Instance Properties

    let name = "hexToAlpha"

    // MARK: - Instance Methods

    func filter(input: String) throws -> Double {
        guard input.hasPrefix("#") else {
            throw StencilFilterError(code: .invalidValue(input), filter: name)
        }

        let hexColor = String(input.dropFirst())

        guard hexColor.count == 8 else {
            throw StencilFilterError(code: .invalidValue(input), filter: name)
        }

        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0

        guard scanner.scanHexInt64(&hexNumber) else {
            throw StencilFilterError(code: .invalidValue(input), filter: name)
        }

        let alpha = Double(hexNumber & 0x000000ff) / 255
        let multiplier = pow(10.0, 2.0)

        return round(alpha * multiplier) / multiplier
    }
}
