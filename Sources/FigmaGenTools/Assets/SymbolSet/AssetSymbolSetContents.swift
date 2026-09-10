import Foundation

public struct AssetSymbolSetContents: Codable, Hashable {

    // MARK: - Instance Properties

    public var info: AssetInfo?
    public var properties: AssetSymbolProperties?
    public var symbols: [AssetImage]?

    // MARK: - Initializers

    public init(
        info: AssetInfo? = AssetInfo(),
        properties: AssetSymbolProperties? = nil,
        symbols: [AssetImage]? = [AssetImage()]
    ) {
        self.info = info
        self.properties = properties
        self.symbols = symbols?.sorted { $0.scale?.rawValue ?? .empty <= $1.scale?.rawValue ?? .empty }
    }
}
