import Foundation

enum AccessTokenConfiguration: Decodable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case environmentVariable = "env"
        case keychain
    }

    // MARK: -

    struct KeychainParameters: Decodable, Equatable {

        // MARK: - Instance Properties

        let service: String
        let key: String
    }

    // MARK: - Enumeration Cases

    case environmentVariable(String)
    case value(String)
    case keychainParameters(KeychainParameters)

    // MARK: - Initializers

    init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            if let environmentVariable = try? container.decode(String.self, forKey: .environmentVariable) {
                self = .environmentVariable(environmentVariable)
            } else if let keychainVariable = try? container.decode(KeychainParameters.self, forKey: .keychain) {
                self = .keychainParameters(keychainVariable)
            } else {
                throw AccessTokenError.failedCreateAccessToken
            }
        } else {
            self = .value(try String(from: decoder))
        }
    }
}
