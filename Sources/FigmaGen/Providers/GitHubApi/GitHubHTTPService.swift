import Foundation
import FigmaGenTools

public protocol GitHubHTTPService {

    // MARK: - Instance Methods

    func request(route: HTTPRoute) -> HTTPTask
}

extension HTTPService: GitHubHTTPService { }
