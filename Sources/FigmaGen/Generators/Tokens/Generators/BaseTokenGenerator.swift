import Foundation

protocol BaseTokenGenerator {

    // MARK: - Instance Methods

    func generate(renderParameters: RenderParameters, tokenValues: TokenValues) throws
}
