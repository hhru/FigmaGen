import Foundation

protocol ThemeTokensGenerator {

    // MARK: - Instance Methods

    func generate(renderParameters: RenderParameters, tokenValues: TokenValues) throws
}
