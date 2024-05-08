import Foundation
import KeychainAccess

final class DefaultAccessTokenResolver: AccessTokenResolver {

    func resolveAccessToken(from configuration: AccessTokenConfiguration?) -> String? {
        switch configuration {
        case let .value(accessToken):
            return accessToken

        case let .environmentVariable(environmentVariable):
            return ProcessInfo.processInfo.environment[environmentVariable]
            
        case let .keychainParameters(value):
            let keychain = Keychain(service: value.service)

            guard let token = try? keychain.getString(value.key) else {
                return nil
            }
            
            return token

        case nil:
            return nil
        }
    }
}
