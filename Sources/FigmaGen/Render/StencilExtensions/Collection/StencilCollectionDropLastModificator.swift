import Foundation

final class StencilCollectionDropLastModificator: StencilModificator {

    // MARK: - Instance Properties

    let name = "dropLast"

    // MARK: - Instance Methods

    func modify(input: Any, withArguments arguments: [Any?]) throws -> Any {
        let count = arguments.first as? Int ?? 1

        if let array = input as? [Any?] {
            return Array(array.dropLast(count))
        }

        return String(stringify(input).dropLast(count))
    }
}
