import Foundation

protocol ColorTokensContextProvider {

    // MARK: - Instance Methods

    func extractTokenContext(from tokenValues: TokenValues) throws -> [String: Any]
}
