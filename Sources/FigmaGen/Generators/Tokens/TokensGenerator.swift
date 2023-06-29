import Foundation

protocol TokensGenerator {

    // MARK: - Instance Methods

    func generate(configuration: TokensConfiguration) async throws
}
