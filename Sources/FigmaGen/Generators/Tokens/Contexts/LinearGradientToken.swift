import Foundation

struct LinearGradientToken: Encodable {

    struct Stop: Encodable {
        let color: ColorToken
        let location: String
    }

    struct ThemeValue: Encodable {
        let stops: [Stop]
        let angle: String
    }

    let path: [String]
    let name: String

    let dayTheme: ThemeValue
    let nightTheme: ThemeValue
    let zpDayTheme: ThemeValue
}
