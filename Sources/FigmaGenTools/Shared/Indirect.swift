import Foundation

public struct Indirect<Value> {

    // MARK: - Nested Types

    fileprivate final class Wrapper {

        // MARK: - Instance Properties

        var value: Value

        // MARK: - Initializers

        init(_ value: Value) {
            self.value = value
        }
    }

    // MARK: - Instance Properties

    private var wrapper: Wrapper

    public var value: Value {
        get { wrapper.value }
        set {
            if isKnownUniquelyReferenced(&wrapper) {
                wrapper.value = newValue
            } else {
                wrapper = Wrapper(newValue)
            }
        }
    }

    // MARK: - Initializers

    public init(_ value: Value) {
        self.wrapper = Wrapper(value)
    }
}

// MARK: - Equatable

extension Indirect.Wrapper: Equatable where Value: Equatable {

    // MARK: - Type Methods

    fileprivate static func == (lhs: Indirect<Value>.Wrapper, rhs: Indirect<Value>.Wrapper) -> Bool {
        lhs.value == rhs.value
    }
}

extension Indirect: Equatable where Value: Equatable { }

// MARK: - Hashable

extension Indirect.Wrapper: Hashable where Value: Hashable {

    // MARK: - Instance Methods

    fileprivate func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

extension Indirect: Hashable where Value: Hashable { }