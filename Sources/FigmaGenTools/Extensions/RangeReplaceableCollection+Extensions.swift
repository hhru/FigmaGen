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

    public func removingFirst() -> Self {
        var copy = self
        copy.removeFirst()
        return copy
    }
}

extension RangeReplaceableCollection where Self: BidirectionalCollection, Self == SubSequence {

    // MARK: - Instance Methods

    public func removingLast() -> Self {
        var copy = self
        copy.removeLast()
        return copy
    }
}
