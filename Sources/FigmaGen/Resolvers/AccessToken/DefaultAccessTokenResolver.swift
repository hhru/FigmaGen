import Foundation
#if os(macOS)
import KeychainAccess
#endif

final class DefaultAccessTokenResolver: AccessTokenResolver {

    func resolveAccessToken(from configuration: AccessTokenConfiguration?) -> String? {
        if let accessToken = configuration?.value {
            return accessToken
        } else if let environmentVariable = configuration?.environmentVariable,
                  let accessToken = ProcessInfo.processInfo.environment[environmentVariable] {
            return accessToken
        } else if let parameters = configuration?.keychainParameters {
        #if os(macOS)
            let accessToken = try? Keychain(service: parameters.service).getString(parameters.key)
            return accessToken
        #else
            return nil
        #endif
        } else {
            return nil
        }
    }
}
