import Foundation
import PathKit

extension Path {

    // MARK: - Instance Methods

    public func appending(_ path: Path) -> Path {
        self + path
    }

    public func appending(_ path: String) -> Path {
        self + path
    }

    public func appending(fileName: String, `extension`: String) -> Path {
        self + "\(fileName).\(`extension`)"
    }
}
