import Foundation

protocol ColorTokensContextProvider {

    // MARK: - Instance Methods

    func extractTokenContext(
        from tokenValues: TokenValues,
        themes: [Theme],
        fallbackTheme: Theme
    ) throws -> [String: Any]
}
