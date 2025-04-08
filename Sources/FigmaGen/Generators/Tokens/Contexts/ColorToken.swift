import Foundation

struct ColorToken: TokenProtocol, Encodable {

    // MARK: - Instance Properties

    let name: String
    let path: [String]
    let value: String
    let reference: String
}
