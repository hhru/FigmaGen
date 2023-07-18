import Foundation

final class StencilCollectionRemovingFirstModificator: StencilModificator {

    // MARK: - Instance Properties

    let name = "removingFirst"

    // MARK: - Instance Methods

    func modify(input: Any, withArguments arguments: [Any?]) throws -> Any {
        guard let element = arguments.first as? String else {
            throw StencilModificatorError(code: .invalidArguments(arguments), filter: name)
        }

        guard let array = input as? [Any?] else {
            throw StencilModificatorError(code: .invalidValue(input), filter: name)
        }

        return array
            .map { stringify($0) }
            .removingFirst(element)
    }
}
