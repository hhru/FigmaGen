import Foundation

extension RangeReplaceableCollection {

    // MARK: - Instance Methods

    public mutating func prepend<T: Collection>(contentsOf collection: T) where Self.Element == T.Element {
        insert(contentsOf: collection, at: startIndex)
    }

    public mutating func prepend(_ element: Element) {
        insert(element, at: startIndex)
    }

    public func prepending<T: Collection>(contentsOf collection: T) -> Self where Self.Element == T.Element {
        collection + self
    }

    public func prepending(_ element: Element) -> Self {
        prepending(contentsOf: [element])
    }

    public func appending<T: Collection>(contentsOf collection: T) -> Self where Self.Element == T.Element {
        self + collection
    }

    public func appending(_ element: Element) -> Self {
        appending(contentsOf: [element])
    }
}

extension RangeReplaceableCollection where Element: Equatable {

    // MARK: - Instance Methods

    @discardableResult
    public mutating func removeFirst(_ element: Element) -> Element? {
        guard let index = firstIndex(of: element) else {
            return nil
        }

        return remove(at: index)
    }

    public func removingFirst(_ element: Element) -> Self {
        var copy = self
        copy.removeFirst(element)
        return copy
    }
}
