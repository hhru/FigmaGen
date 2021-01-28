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
    }

    // MARK: - Instance Properties

    private let alamofireSession: Alamofire.Session
    private let responseDecoder: JSONDecoder

    // MARK: -

    private let accessToken: String

    // MARK: - Initializers

    init(accessToken: String) {
        self.accessToken = accessToken

        alamofireSession = Alamofire.Session()
        responseDecoder = JSONDecoder()

        responseDecoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            if let date = DateFormatter.figmaAPI(withMilliseconds: true).date(from: dateString) {
                return date
            }

            if let date = DateFormatter.figmaAPI(withMilliseconds: false).date(from: dateString) {
                return date
            }

            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Date string does not match format expected by formatter"
            )
        }
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

private extension DateFormatter {

    // MARK: - Type Properties
    static func figmaAPI(withMilliseconds: Bool) -> DateFormatter {
        let dateFormatter = DateFormatter()

        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        if withMilliseconds {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        }

        return dateFormatter
    }
}
