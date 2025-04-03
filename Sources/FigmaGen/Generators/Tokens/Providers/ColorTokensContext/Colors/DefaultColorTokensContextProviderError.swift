import Foundation

enum DefaultColorTokensContextProviderError: Error, CustomStringConvertible {

    case fallbackTokenNotFound(String)

    var description: String {
        switch self {
        case let .fallbackTokenNotFound(tokenName):
            "Fallback color token not found for \(tokenName) token."
        }
    }
}
