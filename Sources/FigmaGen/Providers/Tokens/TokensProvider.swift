import Foundation

protocol TokensProvider {

    // MARK: - Instance Methods

    func fetchTokens(from file: FileParameters) async throws -> TokenValues
}
