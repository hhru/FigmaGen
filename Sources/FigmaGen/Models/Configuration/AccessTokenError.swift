import Foundation

enum AccessTokenError: Error, CustomStringConvertible {

    // MARK: - Instance Properties

    case failedCreateAccessToken

    // MARK: - CustomStringConvertible

    var description: String {
        switch self {
        case .failedCreateAccessToken:
            return "Failed to create access token"
        }
    }
}
