import Foundation

struct TokensStudioPluginData: Codable, Hashable {

    // MARK: - Nested Types

    struct Tokens: Codable, Hashable {

        // MARK: - Instance Properties

        let persistentNodesCache: String
        let version: String
        let values: String
        let usedTokenSet: String
        let updatedAt: String
        let activeTheme: String
        let themes: String
        let collapsedTokenSets: String
        let checkForChanges: String
    }

    // MARK: - Instance Properties

    let tokens: Tokens
}
