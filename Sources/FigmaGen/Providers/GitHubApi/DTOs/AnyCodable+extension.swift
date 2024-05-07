import Foundation
import FigmaGenTools

extension AnyCodable {

    func getAllGitHubTokenValues() -> [GitHubTokenValue] {
        var gitHubTokenValues: [GitHubTokenValue] = []

        guard let dictionary = self.value as? [String: Any] else {
            return gitHubTokenValues
        }

        guard let data = try? JSONEncoder().encode(self) else {
            return []
        }

        if let value = try? JSONDecoder().decode(GitHubTokenValue.self, from: data) {
            return [value]
        } else if let values = try? JSONDecoder().decode([String: GitHubTokenValue].self, from: data) {
            let valuesResult = values.compactMap { key, value in
                let name = value.name ?? key
                return value.copyWith(name: name)
            }
            gitHubTokenValues.append(contentsOf: valuesResult)
        } else {
            let results = dictionary.map { key, value in
                let tokenValues = AnyCodable(value).getAllGitHubTokenValues()
                return tokenValues.map { value in
                    var name = key
                    if let valueName = value.name {
                        name += ".\(valueName)"
                    }
                    return value.copyWith(name: name)
                }
            }

            gitHubTokenValues.append(contentsOf: results.flatMap { $0 })
        }

        return gitHubTokenValues
    }
}
