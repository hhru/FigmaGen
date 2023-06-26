import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public final class HTTPBodyJSONEncoder: HTTPBodyEncoder {

    // MARK: - Type Properties

    public static let `default` = HTTPBodyJSONEncoder(jsonEncoder: JSONEncoder())

    // MARK: - Instance Properties

    public let jsonEncoder: JSONEncoder

    // MARK: - Initializers

    public init(jsonEncoder: JSONEncoder) {
        self.jsonEncoder = jsonEncoder
    }

    // MARK: - Instance Methods

    public func encode<T: Encodable>(request: URLRequest, parameters: T) throws -> URLRequest {
        var request = request

        request.httpBody = try jsonEncoder.encode(parameters)

        if !request.httpBody.isEmptyOrNil {
            if request.value(forHTTPHeaderField: .contentTypeHeaderField) == nil {
                request.setValue(.contentTypeHeaderValue, forHTTPHeaderField: .contentTypeHeaderField)
            }
        }

        return request
    }
}

extension String {

    // MARK: - Type Properties

    fileprivate static let contentTypeHeaderField = "Content-Type"
    fileprivate static let contentTypeHeaderValue = "application/json"
}
