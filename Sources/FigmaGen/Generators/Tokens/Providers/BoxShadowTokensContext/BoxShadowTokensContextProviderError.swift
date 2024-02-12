import Foundation

struct BoxShadowTokensContextProviderError: Error, CustomStringConvertible {

    // MARK: - Nested Types

    enum Code {

        // MARK: - Enumeration Cases

        case nightValueNotFound(tokenName: String)
        case zpValueNotFound(tokenName: String)
    }

    // MARK: - Instance Properties

    let code: Code

    // MARK: - CustomStringConvertible

    var description: String {
        switch code {
        case .nightValueNotFound(let tokenName):
            return "Night value for token '\(tokenName)' not found"
        case .zpValueNotFound(let tokenName):
            return "ZpDay value for token '\(tokenName)' not found"
        }
    }
}
