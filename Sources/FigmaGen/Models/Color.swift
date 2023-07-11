import Foundation

struct Color: Codable, Hashable {

    // MARK: - Instance Properties

    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double
}

extension Color {

    // MARK: - Type Methods

    static func == (lhs: Color, rhs: Color) -> Bool {
        lhs.hexString == rhs.hexString
    }

    // MARK: - Instance Properties

    var hexString: String {
        let multiplier = CGFloat(255.0)

        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }

        return String(
            format: "#%02lX%02lX%02lX%02lX",
            Int(red * multiplier),
            Int(green * multiplier),
            Int(blue * multiplier),
            Int(alpha * multiplier)
        )
    }

    // MARK: - Instance Methods

    func hash(into hasher: inout Hasher) {
        hasher.combine(hexString)
    }
}
