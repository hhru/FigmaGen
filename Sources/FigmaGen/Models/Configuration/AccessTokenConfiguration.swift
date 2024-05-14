import Foundation

struct AccessTokenConfiguration: Decodable {

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

    let value: String?
    let environmentVariable: String?
    let keychainParameters: KeychainParameters?

    // MARK: - Initializers

    init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            self.value = nil
            self.environmentVariable = try container.decodeIfPresent(forKey: .environmentVariable)
            self.keychainParameters = try container.decodeIfPresent(forKey: .keychain)
        } else {
            self.value = try String(from: decoder)
            self.environmentVariable = nil
            self.keychainParameters = nil
        }
    }

    init(
        value: String? = nil,
        environmentVariable: String? = nil,
        keychainParameters: KeychainParameters? = nil
    ) {
        self.value = value
        self.environmentVariable = environmentVariable
        self.keychainParameters = keychainParameters
    }
}
