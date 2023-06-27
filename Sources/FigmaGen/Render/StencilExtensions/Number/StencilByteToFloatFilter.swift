import Foundation

final class StencilByteToFloatFilter: StencilFilter {

    // MARK: - Instance Properties

    let name = "byteToFloat"

    // MARK: - Instance Methods

    func filter(input: UInt8) -> Double {
        Double(input) / Double(255.0)
    }
}
