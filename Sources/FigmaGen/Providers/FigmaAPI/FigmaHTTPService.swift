import Foundation
import FigmaGenTools

public protocol FigmaHTTPService {

    // MARK: - Instance Methods

    func request(route: HTTPRoute) -> HTTPTask
}

extension HTTPService: FigmaHTTPService { }
