import Foundation

protocol TokenProtocol {
    var name: String { get }
    var path: [String] { get }
}

extension TokenProtocol {
    var name: String {
        path.joined(separator: ".")
    }
}
