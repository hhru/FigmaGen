import Foundation

protocol BaseColorTokensGenerator {

    // MARK: - Instance Methods

    func generate(renderParameters: RenderParameters, tokenValues: TokenValues) throws
}
