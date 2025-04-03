import Foundation

protocol BoxShadowTokensContextProvider {

    // MARK: - Instance Methods

    func fetchBoxShadowTokensContext(
        from tokenValues: TokenValues,
        themes: [Theme],
        fallbackTheme: Theme
    ) throws -> [TokenThemeValue<[BoxShadowToken]>]
}
