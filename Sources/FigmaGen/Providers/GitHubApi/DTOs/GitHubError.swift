import FigmaGenTools
import Foundation

struct GitHubError: Error, Hashable, CustomStringConvertible {

    // MARK: - Instance Properties

    let code: Int
    let content: String
    let path: String

    // MARK: - CustomStringConvertible

    init(_ error: HTTPError, path: String) {
        code = error.statusCode?.rawValue ?? 0
        content = error.statusCode?.httpErrorDescription ?? error.description
        self.path = path
    }

    var description: String {
        switch code {
        case 404:
            return "\(type(of: self)) \(content) for '\(path)' (check owner, repo, branch and filePath or access token)"

        case 400...403:
            return "\(type(of: self)) \(content) for '\(path)' (access token error)"

        default:
            return "\(type(of: self)) \(content) for '\(path)'"
        }
    }
}
