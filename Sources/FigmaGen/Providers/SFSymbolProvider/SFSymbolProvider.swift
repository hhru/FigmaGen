import Foundation
import PromiseKit

protocol SFSymbolProvider {

    // MARK: - Instance Methods

    func saveData(
        from url: URL,
        to filePath: String,
        template: String?
    ) -> Promise<Void>
}
