import Foundation

struct ColorToken: TokenProtocol, Encodable {

    // MARK: - Nested Types

    struct ColorValue: Encodable {

        // MARK: - Instance Properties

        let value: String
        let reference: String
    }

    // MARK: - Instance Properties

    let name: String
    let path: [String]
    let themedValue: [String: ColorValue]
}
