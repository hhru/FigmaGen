import Foundation

public struct AssetInfo: Codable, Hashable {

    // MARK: - Type Properties

    public static let defaultFigmaGen = AssetInfo(version: 1, author: "FigmaGen")

    // MARK: - Instance Properties

    public var version: Int?
    public var author: String?

    // MARK: - Initializers

    public init(version: Int? = 1, author: String? = "xcode") {
        self.version = version
        self.author = author
    }
}
