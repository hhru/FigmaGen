import Foundation
import FigmaGenTools
import PromiseKit
import PathKit

final class DefaultDataProvider: DataProvider {

    // MARK: - Instance Properties

    private let dataCache = Cache<URL, Data>()

    // MARK: - Instance Methods

    func fetchData(from url: URL) -> Promise<Data> {
        perform(on: DispatchQueue.global(qos: .userInitiated)) {
            if let data = self.dataCache.value(forKey: url) {
                return data
            }

            return try Data(contentsOf: url)
        }.get { data in
            self.dataCache.setValue(data, forKey: url)
        }
    }

    func saveData(from url: URL, to filePath: String) -> Promise<Void> {
        firstly {
            self.fetchData(from: url)
        }.map(on: DispatchQueue.global(qos: .userInitiated)) { fileData in
            let filePath = Path(filePath)

//            if filePath.exists {
//                try filePath.delete()
//            }

            if filePath.string.lowercased().contains("colored") {
//                print("Data count:", fileData.count)
//
//                print(
//                    "First bytes:",
//                    fileData.prefix(32)
//                        .map { String(format: "%02X", $0) }
//                        .joined(separator: " ")
//                )
//
//                print(
//                    "Content:",
//                    String(data: fileData, encoding: .utf8) ?? "<not UTF-8>"
//                )
//                print(filePath.string)
                let parser = SVGParser()
                let result = try parser.parse(data: fileData)
                let provider = SFSymbolProvider()
                try provider.generate(
                    renderParameters: RenderParameters(
                        template: RenderTemplate(type: .custom(path: "/Users/d.viter/Project/FigmaGen/Templates/SVGTemplate.stencil"), options: [:]),
                        destination: RenderDestination.file(path: filePath.string)
                    ),
                    tokenValues: TokenValues(core: [], semantic: [], colors: [], typography: [], themedTokens: [:]),
                    result: SVGPathsResult(id: filePath.string, canvas: parser.canvas, allPaths: result),
                    themes: [],
                    fallbackTheme: .light
                )
            } else {
                try filePath.parent().mkpath()
                try filePath.write(fileData)
            }

        }
    }
}
