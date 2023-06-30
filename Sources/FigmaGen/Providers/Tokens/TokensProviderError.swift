import Foundation

struct TokensProviderError: Error, CustomStringConvertible {

    // MARK: - Nested Types

    enum Code {
        case sharedPluginDataNotFound
        case unexpectedPluginDataType
        case failedCreateData
    }

    // MARK: - Instance Properties

    let code: Code

    // MARK: - CustomStringConvertible

    var description: String {
        switch code {
        case .sharedPluginDataNotFound:
            return "Shared plugin data in Figma file not found"

        case .unexpectedPluginDataType:
            return "Unexpected plugin data type, must be a dictionary"

        case .failedCreateData:
            return "Failed to create data from json string"
        }
    }
}
