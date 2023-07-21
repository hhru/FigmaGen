import Foundation

protocol FontFamilyTokensGenerator {

    // MARK: - Instance Methods

    func generate(renderParameters: RenderParameters, tokenValues: TokenValues) throws
}
