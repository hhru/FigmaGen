import Foundation

struct ImageNode: Encodable, Hashable {

    // MARK: - Instance Properties

    let id: String
    let name: String
    let description: String?

    // MARK: - Instance Methods

    func isSFSymbol(key: String?) -> Bool {
        key.map { name.lowercased().contains("\($0.lowercased())=true") } ?? false
    }
}
