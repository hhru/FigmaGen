import Foundation

struct LinearGradient: Codable, Hashable {

    // MARK: - Nested Types

    struct LinearColorStop: Codable, Hashable {

        // MARK: - Instance Properties

        let color: Color
        let percentage: String
    }

    // MARK: - Instance Properties

    let angle: String
    let colorStopList: [LinearColorStop]
}

extension LinearGradient {

    var radians: Double {
        if angle.hasSuffix("deg"), let deg = Double(angle.replacingOccurrences(of: "deg", with: "")) {
            return deg * .pi / 180
        }

        if angle.hasSuffix("rad"), let rad = Double(angle.replacingOccurrences(of: "rad", with: "")) {
            return rad
        }

        return Double(angle) ?? .zero
    }
}
