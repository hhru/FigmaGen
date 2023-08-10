import Foundation

public struct Inderect<Value> {

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

extension Inderect.Wrapper: Equatable where Value: Equatable {

    // MARK: - Type Methods

    static func == (lhs: Inderect<Value>.Wrapper, rhs: Inderect<Value>.Wrapper) -> Bool {
        lhs.value == rhs.value
    }
}

extension Inderect: Equatable where Value: Equatable { }

// MARK: - Hashable

extension Inderect.Wrapper: Hashable where Value: Hashable {

    // MARK: - Instance Methods

    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

extension Inderect: Hashable where Value: Hashable { }
