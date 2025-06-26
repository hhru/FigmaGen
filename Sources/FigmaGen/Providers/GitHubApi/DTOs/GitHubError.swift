import FigmaGenTools
import Foundation

struct GitHubError: Error, Hashable, CustomStringConvertible {

    // MARK: - Instance Properties

    let code: Int
    let content: String

    // MARK: - CustomStringConvertible

    init(_ error: HTTPError) {
        code = error.statusCode?.rawValue ?? 0
        content = error.statusCode?.httpErrorDescription ?? ""
    }

    var description: String {
        if 400...404 ~= code {
            return "\(type(of: self)) \(content) (access token error)"
        }

        return "\(type(of: self)) \(content)"
    }
}
