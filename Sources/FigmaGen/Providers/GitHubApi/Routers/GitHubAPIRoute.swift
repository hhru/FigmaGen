import Foundation
import FigmaGenTools

protocol GitHubAPIRoute {

    // MARK: - Nested Types

    associatedtype Response: Decodable

    // MARK: - Instance Properties

    var httpMethod: HTTPMethod { get }
    var urlPath: String { get }
    var accessToken: String? { get }
}

extension GitHubAPIRoute {

    // MARK: - Instance Properties

    var httpMethod: HTTPMethod {
        .get
    }

    var accessToken: String? {
        nil
    }
}
