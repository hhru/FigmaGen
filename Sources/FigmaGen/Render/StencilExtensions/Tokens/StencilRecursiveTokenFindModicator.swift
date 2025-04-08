import Foundation

struct StencilRecursiveTokenFindModicator: StencilModificator {

    // MARK: - Instance Properties

    let name = "findTokenInThemes"

    // MARK: - Instance Methods

    func modify(input: Any, withArguments arguments: [Any?]) throws -> Any {
        guard arguments.count > 1 else {
            throw StencilModificatorError(code: .invalidArguments(arguments), filter: name)
        }

        guard
            let themesDict = input as? [String: [String: Any]],
            let pathString = arguments[0] as? String,
            let key = arguments[1] as? String
        else {
            return input
        }

        let pathComponents = pathString.split(separator: ".").map(String.init)
        var result: [String: Any] = [:]

        for (themeName, structuredDict) in themesDict {
            if let token = findToken(
                in: structuredDict,
                name: pathString,
                path: pathComponents,
                key: key
            ) {
                result[themeName] = token
            }
        }

        return result
    }

    private func findToken(
        in dict: [String: Any],
        name: String,
        path: [String],
        key: String
    ) -> Any? {
        if let tokens = dict[key] as? [TokenProtocol], let found = tokens.first(where: { $0.name == name }) {
            return found
        }

        guard !path.isEmpty else {
            return nil
        }

        guard let children = dict["children"] as? [[String: Any]] else {
            return nil
        }

        for child in children {
            if let childName = child["name"] as? String, childName == path[0] {
                return findToken(
                    in: child,
                    name: name,
                    path: Array(path.dropFirst()),
                    key: key
                )
            }
        }

        return nil
    }
}
