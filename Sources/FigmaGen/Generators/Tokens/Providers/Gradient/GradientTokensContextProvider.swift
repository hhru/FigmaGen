import Foundation

protocol GradientTokensContextProvider {

    func extractContext(from tokenValues: TokenValues) throws -> [String : Any]
}
