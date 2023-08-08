import Foundation

struct ImageSet: Encodable, Hashable {

    // MARK: - Instance Properties

    let name: String
    let images: [Image]
}
