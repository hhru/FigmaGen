import Foundation

public struct AssetSymbolSet: AssetNode {

    // MARK: - Type Properties

    public static let pathExtension = "symbolset"

    // MARK: - Instance Properties

    public var contents: AssetSymbolSetContents

    // MARK: - Initializers

    public init(contents: AssetSymbolSetContents = AssetSymbolSetContents()) {
        self.contents = contents
    }
}
