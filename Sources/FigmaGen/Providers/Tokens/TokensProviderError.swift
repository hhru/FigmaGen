import Foundation

struct TokensProviderError: Error, CustomStringConvertible {

    // MARK: - Nested Types

    enum Code {
        case sharedPluginDataNotFound
        case unexpectedPluginDataType
        case failedCreateData
        case unsupportedManifestSchema(schema: String)
        case manifestCollectionNotFound(name: String)
        case tokensFileNotFound(path: String)
        case invalidTokenValue(name: String, type: String)
        case themeNotFound(theme: String)
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

        case let .unsupportedManifestSchema(schema):
            return """
                Unsupported tokens manifest schema '\(schema)', expected '\(SXLTokensManifest.schema)'. \
                Monolithic Tokens Studio JSON is no longer supported, specify path to the SXL Studio manifest \
                (e.g. 'tokens/config.json') in 'filePath'
                """

        case let .manifestCollectionNotFound(name):
            return "Collection '\(name)' not found in tokens manifest"

        case let .tokensFileNotFound(path):
            return "Tokens file '\(path)' not found"

        case let .invalidTokenValue(name, type):
            return "Invalid value of token '\(name)' with type '\(type)'"

        case let .themeNotFound(theme):
            return "Theme '\(theme)' not found in tokens manifest"
        }
    }
}
