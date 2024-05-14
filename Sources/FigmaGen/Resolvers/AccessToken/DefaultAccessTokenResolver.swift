import Foundation
import KeychainAccess

final class DefaultAccessTokenResolver: AccessTokenResolver {

    func resolveAccessToken(from configuration: AccessTokenConfiguration?) -> String? {
        if let accesToken = configuration?.value {
            return accesToken
        } else if let environmentVariable = configuration?.environmentVariable,
                  let accessToken = ProcessInfo.processInfo.environment[environmentVariable] {
            return accessToken
        } else if let parameters = configuration?.keychainParameters,
                  let accessToken = try? Keychain(service: parameters.service).getString(parameters.key) {
            return accessToken
        } else {
            return nil
        }
    }
}
