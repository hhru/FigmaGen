import Foundation

final class StencilCollectionDropFirstModificator: StencilModificator {

    // MARK: - Instance Properties

    let name = "dropFirst"

    // MARK: - Instance Methods

    func modify(input: Any, withArguments arguments: [Any?]) throws -> Any {
        let count = arguments.first as? Int ?? 1

        if let array = input as? [Any?] {
            return Array(array.dropFirst(count))
        }

        return String(stringify(input).dropFirst(count))
    }
}
