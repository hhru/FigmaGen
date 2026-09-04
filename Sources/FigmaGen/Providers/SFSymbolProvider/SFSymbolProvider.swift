import Foundation
import PromiseKit

protocol SFSymbolProvider {

    func saveSymbol(
        from url: URL,
        to filePath: String,
        parameters: ImagesParameters
    ) -> Promise<Void>
}
