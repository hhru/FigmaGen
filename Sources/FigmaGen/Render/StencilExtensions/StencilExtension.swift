import Foundation
import Stencil

protocol StencilExtension {

    // MARK: - Instance Properties

    var name: String { get }

    // MARK: - Instance Methods

    func register(in extensionRegistry: ExtensionRegistry)
}

extension StencilExtension {

    // MARK: - Instance Methods

    private func unwrap(_ array: [Any?]) -> [Any] {
        array.map { item in
            if let item {
                if let items = item as? [Any?] {
                    return unwrap(items)
                }

                return item
            }

            return item as Any
        }
    }

    func stringify(_ result: Any?) -> String {
        switch result {
        case let result as String:
            return result

        case let array as [Any?]:
            return unwrap(array).description

        case let result as CustomStringConvertible:
            return result.description

        case let result as NSObject:
            return result.description

        default:
            return .empty
        }
    }
}
