import Foundation

enum DefaultGradientTokensContextProviderError: Error, CustomStringConvertible {
    case invalidAngle(String)
    case fallbackTokenNotFound(String)

    var description: String {
        switch self {
        case .invalidAngle(let tokenName):
            "Invalid agnle in gradient token: \(tokenName)"
        case .fallbackTokenNotFound(let tokenName):
            "Fallback token not found for \(tokenName)"
        }
    }
}
