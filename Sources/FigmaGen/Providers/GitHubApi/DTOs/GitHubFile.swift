import Foundation
import FigmaGenTools

struct GitHubFile: Codable, Hashable {

    let tokenValues: [String: [GitHubTokenValue]]

    enum CodingKeys: String, CodingKey {
        case results
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyKey.self)
        
        tokenValues = container.allKeys
            .map { key -> (key: AnyKey, values: [GitHubTokenValue]?) in
                let parametersForKey = try? container.decodeIfPresent([String: AnyCodable].self, forKey: key)
                let tokenValues = parametersForKey?
                    .map { key, value in
                        let result: [GitHubTokenValue] = value
                            .getAllGitHubTokenValues()
                            .map { githubValue in
                                var name = key
                                if let valueName = githubValue.name {
                                    name += ".\(valueName)"
                                }
                                return githubValue.copyWith(name: name)
                            }
                            .sorted(by: { $0.name ?? "" < $1.name ?? "" })
                        return result
                    }
                    .flatMap { $0 }

                return (key: key, values: tokenValues)
            }
            .reduce(into: [String: [GitHubTokenValue]]()) { partialResult, mapResult in
                partialResult[mapResult.key.stringValue] = mapResult.values
            }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        try container.encode(tokenValues)
    }
}
