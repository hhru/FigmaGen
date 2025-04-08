import Foundation

extension ColorTokensContextProvider {

    func structure<T: Encodable & TokenProtocol>(
        tokens: [T],
        atNamePath namePath: [String] = [],
        contextName: String = "tokens"
    ) -> [String: Any] {
        var structuredTokens: [String: Any] = [:]

        if let name = namePath.last {
            structuredTokens["name"] = name
        }

        if !namePath.isEmpty {
            structuredTokens["path"] = namePath
        }

        let filteredTokens = tokens
            .filter { $0.path.count == namePath.count + 1 }
            .sorted { $0.name.lowercased() < $1.name.lowercased() }

        if !filteredTokens.isEmpty {
            structuredTokens[contextName] = filteredTokens
        }

        let childTokens = tokens.filter { $0.path.count > namePath.count + 1 }

        let children = Dictionary(grouping: childTokens) { $0.path[namePath.count] }
            .sorted { $0.key < $1.key }
            .map { name, tokens in
                structure(tokens: tokens, atNamePath: namePath + [name], contextName: contextName)
            }

        if !children.isEmpty {
            structuredTokens["children"] = children
        }

        return structuredTokens
    }
}
