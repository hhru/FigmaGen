import Foundation

protocol BoxShadowTokensContextProvider {

    // MARK: - Instance Methods

    func fetchBoxShadowTokensContext(from tokenValues: TokenValues) throws -> [BoxShadowToken]
}
