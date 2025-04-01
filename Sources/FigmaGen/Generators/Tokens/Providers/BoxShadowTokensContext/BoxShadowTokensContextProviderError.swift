import Foundation

struct BoxShadowTokensContextProviderError: Error, CustomStringConvertible {

    // MARK: - Nested Types

    enum Code {

        // MARK: - Enumeration Cases

        case valueNotFound(tokenName: String, theme: String)
    }

    // MARK: - Instance Properties

    let code: Code

    // MARK: - CustomStringConvertible

    var description: String {
        switch code {
        case let .valueNotFound(tokenName, theme):
            return "\(theme) value for token '\(tokenName)' not found"
        }
    }
}
