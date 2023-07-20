import Foundation

struct ColorToken: Encodable {

    // MARK: - Nested Types

    struct Theme: Encodable {

        // MARK: - Instance Properties

        let value: String
        let reference: String
    }

    // MARK: - Instance Properties

    let dayTheme: Theme
    let nightTheme: Theme
    let name: String
    let path: [String]
}
