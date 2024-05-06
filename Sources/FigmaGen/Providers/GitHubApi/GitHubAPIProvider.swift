import Foundation
import PromiseKit
import FigmaGenTools

final class GitHubAPIProvider: RemoteRepoProvider {

    // MARK: - Instance Properties

    private let queryEncoder: HTTPQueryEncoder
    private let bodyEncoder: HTTPBodyEncoder
    private let responseDecoder: HTTPResponseDecoder
    private let baseURL = URL(string: "https://raw.githubusercontent.com")!

    // MARK: -

    let httpService: GitHubHTTPService

    init(httpService: GitHubHTTPService) {
        self.httpService = httpService

        let urlEncoder = URLEncoder(boolEncodingStrategy: .literal)
        let jsonEncoder = JSONEncoder()
        let jsonDecoder = JSONDecoder()

        urlEncoder.dateEncodingStrategy = .formatted(.gitHubAPI(withMilliseconds: true))
        jsonEncoder.dateEncodingStrategy = .formatted(.gitHubAPI(withMilliseconds: true))

        jsonDecoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            if let date = DateFormatter.gitHubAPI(withMilliseconds: true).date(from: dateString) {
                return date
            }

            if let date = DateFormatter.gitHubAPI(withMilliseconds: false).date(from: dateString) {
                return date
            }

            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Date string does not match format expected by formatter"
            )
        }

        self.queryEncoder = HTTPQueryURLEncoder(urlEncoder: urlEncoder)
        self.bodyEncoder = HTTPBodyJSONEncoder(jsonEncoder: jsonEncoder)
        self.responseDecoder = jsonDecoder
    }

    private func makeHTTPRoute<Route: GitHubAPIRoute>(for route: Route) -> HTTPRoute {
        let url = baseURL
            .appendingPathComponent(route.urlPath)

        let headers = route.accessToken.map { [HTTPHeader.gitHubAccessToken($0)] } ?? []

        return HTTPRoute(
            method: route.httpMethod,
            url: url,
            headers: headers
        )
    }

    private func handleHTTPError(_ error: HTTPError) -> Error {
        guard let errorData = error.data, error.reason is HTTPStatusCode else {
            return error
        }

        guard let apiError = try? responseDecoder.decode(FigmaError.self, from: errorData) else {
            return error
        }

        return apiError
    }
}

// MARK: - RemoteRepoProvider
extension GitHubAPIProvider {

    func request<Route: GitHubAPIRoute>(route: Route) -> Promise<Route.Response> {
        Promise { seal in

            let task = httpService.request(route: makeHTTPRoute(for: route))

            task.responseDecodable(type: GitHubFile.self, decoder: responseDecoder) { response in
                switch response.result {
                case let .failure(error):
                    seal.reject(self.handleHTTPError(error))

                case let .success(value):
                    if let value = value as? Route.Response {
                        seal.fulfill(value)
                    }
                }
            }
        }
    }

    func request<Route: GitHubAPIRoute>(route: Route) -> Promise<Void> where Route.Response == GitHubAPIEmptyResponse {
        Promise { seal in

            let task = httpService.request(route: makeHTTPRoute(for: route))

            task.responseJSON { response in
                switch response.result {
                case let .failure(error):
                    seal.reject(self.handleHTTPError(error))

                case .success:
                    seal.fulfill(Void())
                }
            }
        }
    }
}

extension HTTPHeader {

    // MARK: - Type Methods

    fileprivate static func gitHubAccessToken(_ value: String) -> HTTPHeader {
        .authorization(bearerToken: value)
    }
}

extension DateFormatter {

    // MARK: - Type Properties

    fileprivate static func gitHubAPI(withMilliseconds: Bool) -> DateFormatter {
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
