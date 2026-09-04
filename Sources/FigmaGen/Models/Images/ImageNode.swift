import Foundation

struct ImageNode: Encodable, Hashable {

    // MARK: - Instance Properties

    let id: String
    let name: String
    let description: String?

    // MARK: - Instance Methods

    func isSFSymbol(key: String?) -> Bool {
        key.map { name.contains("\($0)=true") } ?? false
    }
}
