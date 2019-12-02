//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation
import PromiseKit
import Alamofire

final class DefaultFigmaAPIProvider {

    // MARK: - Nested Types

    private enum Constants {
        static let serverBaseURL = URL(string: "https://api.figma.com")!
        static let accessTokenHeaderName = "X-Figma-Token"
        static let codingDateLocale = Locale(identifier: "en_US_POSIX")
        static let codingDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
    }

    // MARK: - Instance Properties

    private let alamofireSession: Alamofire.Session
    private let responseDecoder: JSONDecoder

    // MARK: -

    private let accessToken: String

    // MARK: - Initializers

    init(accessToken: String) {
        self.accessToken = accessToken

        let dateFormatter = DateFormatter()

        dateFormatter.locale = Constants.codingDateLocale
        dateFormatter.dateFormat = Constants.codingDateFormat
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent

        alamofireSession = Alamofire.Session()
        responseDecoder = JSONDecoder()

        responseDecoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
}

extension DefaultFigmaAPIProvider: FigmaAPIProvider {

    // MARK: - Instance Methods

    func request<Route: FigmaAPIRoute>(route: Route) -> Promise<Route.Response> {
        let url = Constants.serverBaseURL
            .appendingPathComponent(route.apiVersion.urlPath)
            .appendingPathComponent(route.urlPath)

        let accessTokenHTTPHeader = HTTPHeader(name: Constants.accessTokenHeaderName, value: accessToken)

        let httpMethod = HTTPMethod(rawValue: route.httpMethod.rawValue)
        let httpHeaders = HTTPHeaders([accessTokenHTTPHeader])

        return Promise { seal in
            alamofireSession.request(
                url,
                method: httpMethod,
                parameters: route.parameters,
                headers: httpHeaders
            )
            .validate()
            .responseDecodable(of: Route.Response.self, decoder: responseDecoder) { response in
                switch response.result {
                case let .failure(error):
                    seal.reject(error)

                case let .success(value):
                    seal.fulfill(value)
                }
            }
        }
    }
}
