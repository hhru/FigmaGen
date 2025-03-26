import Foundation

struct DefaultGradientTokensContextProvider: GradientTokensContextProvider {

    // MARK: - GradientTokensContextProvider

    func extractContext(from tokenValues: TokenValues) throws -> [String : Any] {
        [:]
    }
}
