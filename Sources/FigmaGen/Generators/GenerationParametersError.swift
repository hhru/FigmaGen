import Foundation

enum GenerationParametersError: Error, CustomStringConvertible {

    // MARK: - Enumeration Cases

    case invalidFileConfiguration
    case invalidAccessToken
    case invalidGitHubAccessToken

    // MARK: - Instance Properties

    var description: String {
        switch self {
        case .invalidFileConfiguration:
            return "Figma file configuration cannot be nil"

        case .invalidAccessToken:
            return "Figma access token cannot be empty or nil"

        case .invalidGitHubAccessToken:
            return "GitHiub access token cannot be empty or nil"
        }
    }
}
