import Foundation

protocol ColorTokensContextProvider {

    // MARK: - Instance Methods

    func fetchColorTokensContext(from tokenValues: TokenValues) throws -> [String: Any]
}
