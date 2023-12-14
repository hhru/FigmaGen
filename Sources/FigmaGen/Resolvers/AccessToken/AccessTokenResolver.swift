import Foundation

protocol AccessTokenResolver {

    func resolveAccessToken(from configuration: AccessTokenConfiguration?) -> String?

}