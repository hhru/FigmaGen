import Foundation

struct BoxShadowToken {

    // MARK: - Nested Types

    struct Theme {

        // MARK: - Instance Properties

        let color: String
        let type: String
        let x: String
        let y: String
        let blur: String
        let spread: String
    }

    // MARK: - Instance Properties

    let path: [String]
    let dayTheme: Theme
    let nightTheme: Theme
    let zpDayTheme: Theme
}
