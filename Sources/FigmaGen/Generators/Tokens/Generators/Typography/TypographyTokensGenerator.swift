import Foundation

protocol TypographyTokensGenerator {

    // MARK: - Instance Methods

    func generate(renderParameters: RenderParameters, tokenValues: TokenValues) throws
}
