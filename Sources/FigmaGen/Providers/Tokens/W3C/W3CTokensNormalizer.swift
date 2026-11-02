import Foundation

/// Приводит токены в формате W3C (DTCG), разложенные по файлам манифеста SXL Studio,
/// к внутреннему формату `TokenValues`, с которым работают генераторы.
struct W3CTokensNormalizer {

    // MARK: - Nested Types

    struct Leaf {
        let name: String
        let type: String?
        let value: W3CTokenJSON
    }

    // MARK: - Instance Properties

    let includeDisabled: Bool
    let warn: (String) -> Void

    // MARK: - Initializers

    init(includeDisabled: Bool = false, warn: @escaping (String) -> Void = { logger.warning($0) }) {
        self.includeDisabled = includeDisabled
        self.warn = warn
    }

    // MARK: - Instance Methods

    /// - Parameters:
    ///   - manifest: Манифест токенов.
    ///   - files: Содержимое файлов токенов по путям из манифеста.
    ///   - mapping: Соответствие наборов токенов коллекциям манифеста.
    func normalize(
        manifest: SXLTokensManifest,
        files: [String: W3CTokenJSON],
        mapping: W3CTokenSetsMapping
    ) throws -> TokenValues {
        let themesCollection = try collection(named: mapping.themes, in: manifest)

        let themedTokens = try themesCollection.modes
            .filter { includeDisabled || $0.isEnabled }
            .map { mode in
                let value = (Theme(mode.name), try tokens(of: [mode], files: files))
                return value
            }

        return TokenValues(
            core: try tokens(ofSingleModeCollectionNamed: mapping.core, in: manifest, files: files),
            semantic: try tokens(ofSingleModeCollectionNamed: mapping.semantic, in: manifest, files: files),
            colors: try tokens(ofSingleModeCollectionNamed: mapping.colors, in: manifest, files: files),
            typography: try tokens(ofSingleModeCollectionNamed: mapping.typography, in: manifest, files: files),
            themedTokens: Dictionary(themedTokens) { first, _ in first }
        )
    }

    /// Токены коллекции, которая не является темами: несколько режимов в ней дали бы токены с одинаковыми именами.
    private func tokens(
        ofSingleModeCollectionNamed name: String,
        in manifest: SXLTokensManifest,
        files: [String: W3CTokenJSON]
    ) throws -> [TokenValue] {
        let modes = try collection(named: name, in: manifest).modes
            .filter { includeDisabled || $0.isEnabled }

        guard modes.count <= 1 else {
            throw TokensProviderError(code: .manifestCollectionHasMultipleModes(name: name, modes: modes.map(\.name)))
        }

        return try tokens(of: modes, files: files)
    }

    private func collection(named name: String, in manifest: SXLTokensManifest) throws -> SXLTokensCollection {
        guard let collection = manifest.collection(named: name) else {
            throw TokensProviderError(code: .manifestCollectionNotFound(name: name))
        }

        guard includeDisabled || collection.isEnabled else {
            throw TokensProviderError(code: .manifestCollectionNotEnabled(name: name))
        }

        return collection
    }

    private func tokens(of modes: [SXLTokensMode], files: [String: W3CTokenJSON]) throws -> [TokenValue] {
        try modes
            .filter { includeDisabled || $0.isEnabled }
            .flatMap { includeDisabled ? $0.allFiles : $0.enabledFiles }
            .flatMap { filePath -> [Leaf] in
                guard let file = files[filePath] else {
                    throw TokensProviderError(code: .tokensFileNotFound(path: filePath))
                }

                return leaves(of: file, path: [], inheritedType: nil)
            }
            .compactMap { try makeTokenValue(from: $0) }
            .sorted { $0.name < $1.name }
    }

    private func leaves(of json: W3CTokenJSON, path: [String], inheritedType: String?) -> [Leaf] {
        guard let object = json.objectValue else {
            return []
        }

        let type = object["$type"]?.stringValue ?? inheritedType

        if let value = object["$value"] {
            return [Leaf(name: path.joined(separator: "."), type: type, value: value)]
        }

        return object
            .filter { !$0.key.hasPrefix("$") }
            .flatMap { key, child in
                leaves(of: child, path: path + [key], inheritedType: type)
            }
    }

    private func makeTokenValue(from leaf: Leaf) throws -> TokenValue? {
        guard let type = try makeTokenValueType(from: leaf) else {
            warn("Token '\(leaf.name)' has unsupported type '\(leaf.type ?? "nil")' and will be skipped")
            return nil
        }

        return TokenValue(type: type, name: leaf.name)
    }

    // swiftlint:disable:next function_body_length
    private func makeTokenValueType(from leaf: Leaf) throws -> TokenValueType? {
        let value = leaf.value

        switch leaf.type {
        case "color":
            return .color(value: try string(value, leaf))

        case "spacing":
            return .spacing(value: try string(value, leaf))

        case "sizing":
            return .sizing(value: try string(value, leaf))

        case "dimension":
            return .dimension(value: try string(value, leaf))

        case "borderRadius":
            return .borderRadius(value: try string(value, leaf))

        case "borderWidth":
            return .borderWidth(value: try string(value, leaf))

        case "opacity":
            return .opacity(value: try string(value, leaf))

        case "blur":
            return .blur(value: try string(value, leaf))

        case "letterSpacing":
            return .letterSpacing(value: try string(value, leaf))

        case "paragraphSpacing":
            return .paragraphSpacing(value: try string(value, leaf))

        case "textCase":
            return .textCase(value: try string(value, leaf))

        case "textDecoration":
            return .textDecoration(value: try string(value, leaf))

        case "fontSize", "fontSizes":
            return .fontSizes(value: try string(value, leaf))

        case "lineHeight", "lineHeights":
            return .lineHeights(value: try string(value, leaf))

        case "fontWeight", "fontWeights":
            return .fontWeights(value: try string(value, leaf))

        case "fontFamily", "fontFamilies":
            if let families = value.arrayValue {
                return .fontFamilies(value: families.compactMap { $0.stringValue }.joined(separator: ", "))
            }

            return .fontFamilies(value: try string(value, leaf))

        case "a11yScales":
            return .a11yScales(value: try string(value, leaf))

        case "scaling":
            return .scaling(value: try string(value, leaf))

        case "number", "core":
            return .core(value: try string(value, leaf))

        default:
            return try makeCompositeTokenValueType(from: leaf)
        }
    }

    // MARK: - Values

    func string(_ value: W3CTokenJSON, _ leaf: Leaf) throws -> String {
        guard let string = value.stringValue else {
            throw invalidValueError(leaf)
        }

        return string
    }

    // MARK: - Helpers

    func invalidValueError(_ leaf: Leaf) -> TokensProviderError {
        TokensProviderError(code: .invalidTokenValue(name: leaf.name, type: leaf.type ?? "nil"))
    }
}
