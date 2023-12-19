import Foundation

final class DefaultAccessTokenResolver: AccessTokenResolver {

    func resolveAccessToken(from configuration: AccessTokenConfiguration?) -> String? {
        switch configuration {
        case let .value(accessToken):
            return accessToken

        case let .environmentVariable(environmentVariable):
            return ProcessInfo.processInfo.environment[environmentVariable]

        case nil:
            return nil
        }
    }
}
