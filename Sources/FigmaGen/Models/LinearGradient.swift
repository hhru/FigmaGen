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
