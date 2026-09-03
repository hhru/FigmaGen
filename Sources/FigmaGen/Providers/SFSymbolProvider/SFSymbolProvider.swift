import Foundation
import PromiseKit

protocol SFSymbolProvider {

    func saveData(
        from url: URL,
        to filePath: String,
        template: String?
    ) -> Promise<Void>
}
