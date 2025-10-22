import Foundation

enum GenerationParametersError: Error, CustomStringConvertible {

    // MARK: - Enumeration Cases

    case invalidFileConfiguration
    case invalidAccessToken
    case invalidGitHubAccessToken
    case emptyGitHubAccessToken

    // MARK: - Instance Properties

    var description: String {
        switch self {
        case .invalidFileConfiguration:
            return "Figma file configuration cannot be nil"

        case .invalidAccessToken:
            return "Figma access token cannot be empty or nil"

        case .invalidGitHubAccessToken:
            return "GitHiub access token cannot be empty or nil"

        case .emptyGitHubAccessToken:
            return "GitHiub access token is empty or nil, if your repository is private, add GitHiub access token."
        }
    }
}
