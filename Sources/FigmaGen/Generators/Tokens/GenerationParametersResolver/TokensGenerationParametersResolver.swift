import Foundation

protocol TokensGenerationParametersResolver {

    // MARK: - Instance Methods

    func resolveGenerationParameters(from configuration: TokensConfiguration) throws -> TokensGenerationParameters
}
