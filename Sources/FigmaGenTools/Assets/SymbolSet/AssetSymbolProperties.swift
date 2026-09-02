import Foundation

public struct AssetSymbolProperties: Codable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case symbolRenderingIntent = "symbol-rendering-intent"
    }

    // MARK: - Instance Properties

    public var symbolRenderingIntent: AssetSymbolRenderingIntent?

    // MARK: - Initializers

    public init(
        symbolRenderingIntent: AssetSymbolRenderingIntent? = nil
    ) {
        self.symbolRenderingIntent = symbolRenderingIntent
    }
}
