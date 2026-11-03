import Foundation

struct TokensProviderError: Error, CustomStringConvertible {

    // MARK: - Nested Types

    enum Code {
        case sharedPluginDataNotFound
        case unexpectedPluginDataType
        case failedCreateData
        case unsupportedManifestSchema(schema: String)
        case manifestCollectionNotFound(name: String)
        case manifestCollectionNotEnabled(name: String)
        case manifestCollectionHasMultipleModes(name: String, modes: [String])
        case tokensFileNotFound(path: String)
        case invalidTokenValue(name: String, type: String)
        case invalidTokenField(name: String, field: String)
        case multipleShadowsNotSupported(name: String, count: Int)
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

        case let .manifestCollectionNotEnabled(name):
            return "Collection '\(name)' not enabled in tokens manifest"

        case let .manifestCollectionHasMultipleModes(name, modes):
            return "Collection '\(name)' has several modes (\(modes.joined(separator: ", "))), only single mode is supported"

        case let .tokensFileNotFound(path):
            return "Tokens file '\(path)' not found"

        case let .invalidTokenValue(name, type):
            return "Invalid value of token '\(name)' with type '\(type)'"

        case let .invalidTokenField(name, field):
            return "Token '\(name)' has missing or invalid field '\(field)'"

        case let .multipleShadowsNotSupported(name, count):
            return "Token '\(name)' contains \(count) shadows, only single shadow is supported"

        case let .themeNotFound(theme):
            return "Theme '\(theme)' not found in tokens manifest"
        }
    }
}
