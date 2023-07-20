import Foundation
import PromiseKit

extension Promise {

    // MARK: - Type Methods

    public static func error(_ error: Error) -> Promise<T> {
        Promise(error: error)
    }

    // MARK: - Initializers

    public convenience init(asyncFunc: @escaping () async throws -> T) {
        self.init { resolver in
            Task {
                do {
                    let result = try await asyncFunc()
                    resolver.fulfill(result)
                } catch {
                    resolver.reject(error)
                }
            }
        }
    }

    // MARK: - Instance Methods

    public func nest<U: Thenable>(
        on queue: DispatchQueue? = conf.Q.map,
        flags: DispatchWorkItemFlags? = nil,
        _ body: @escaping(T) throws -> U
    ) -> Promise<T> {
        then(on: queue, flags: flags) { value in
            try body(value).map(on: nil) { _ in
                value
            }
        }
    }

    public func asOptional() -> Promise<T?> {
        map(on: nil) { $0 as T? }
    }
}

public func perform<T>(
    on queue: DispatchQueue? = conf.Q.map,
    flags: DispatchWorkItemFlags? = nil,
    _ body: @escaping () throws -> T
) -> Promise<T> {
    Promise<T> { seal in
        let work = {
            do {
                seal.fulfill(try body())
            } catch {
                seal.reject(error)
            }
        }

        if let queue {
            queue.async(flags: flags, work)
        } else {
            work()
        }
    }
}
