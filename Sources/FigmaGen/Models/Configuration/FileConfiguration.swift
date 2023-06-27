import Foundation

struct FileConfiguration: Decodable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case key
        case version
        case includedNodes
        case excludedNodes
    }

    // MARK: - Instance Properties

    let key: String
    let version: String?
    let includedNodes: [String]?
    let excludedNodes: [String]?

    // MARK: - Initializers

    init(
        key: String,
        version: String?,
        includedNodes: [String]?,
        excludedNodes: [String]?
    ) {
        self.key = key
        self.version = version
        self.includedNodes = includedNodes
        self.excludedNodes = excludedNodes
    }

    init?(url: URL) {
        guard url.scheme == .fileURLScheme, url.host == .fileURLHost else {
            return nil
        }

        guard url.pathComponents.count == .filePathComponentCount else {
            return nil
        }

        key = url.pathComponents[.fileKeyPathComponentIndex]

        let urlComponents = URLComponents(string: url.absoluteString)
        let urlQueryItems = urlComponents.flatMap { $0.queryItems }

        if let urlQueryItems {
            version = urlQueryItems
                .first { $0.name == .fileURLVersionParameterName }?
                .value

            includedNodes = urlQueryItems
                .first { $0.name == .fileURLNodeParameterName }?
                .value
                .map { [$0] }
        } else {
            version = nil
            includedNodes = nil
        }

        excludedNodes = nil
    }

    init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            self.init(
                key: try container.decode(forKey: .key),
                version: try container.decodeIfPresent(forKey: .version),
                includedNodes: try container.decodeIfPresent(forKey: .includedNodes),
                excludedNodes: try container.decodeIfPresent(forKey: .excludedNodes)
            )
        } else {
            let urlContainer = try decoder.singleValueContainer()
            let url = try urlContainer.decode(URL.self)

            guard let configuration = Self(url: url) else {
                throw DecodingError.dataCorruptedError(
                    in: urlContainer,
                    debugDescription: "'\(url)' is not a valid Figma file URL"
                )
            }

            self = configuration
        }
    }
}

extension String {

    // MARK: - Type Properties

    fileprivate static let fileURLScheme = "https"
    fileprivate static let fileURLHost = "www.figma.com"
    fileprivate static let fileURLVersionParameterName = "version-id"
    fileprivate static let fileURLNodeParameterName = "node-id"
}

extension Int {

    // MARK: - Type Properties

    fileprivate static let filePathComponentCount = 4
    fileprivate static let fileKeyPathComponentIndex = 2
}
