import Foundation

extension Collection {

    // MARK: - Instance Methods

    public func contains(index: Index) -> Bool {
        ((index >= startIndex) && (index < endIndex))
    }

    public subscript(safe index: Index) -> Element? {
        contains(index: index) ? self[index] : nil
    }
}
