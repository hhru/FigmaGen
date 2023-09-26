import Foundation
import DictionaryCoder

final class DefaultTokensProvider: TokensProvider {

    // MARK: - Instance Properties

    let apiProvider: FigmaAPIProvider

    let dictionaryDecoder = DictionaryDecoder()
    let jsonDecoder = JSONDecoder()

    // MARK: - Initializers

    init(apiProvider: FigmaAPIProvider) {
        self.apiProvider = apiProvider
    }

    // MARK: - Instance Methods

    private func extractTokens(from file: FigmaFile) throws -> TokenValues {
        guard let sharedPluginData = file.document.sharedPluginData else {
            throw TokensProviderError(code: .sharedPluginDataNotFound)
        }

        guard case .dictionary(let rawPluginData) = sharedPluginData else {
            throw TokensProviderError(code: .unexpectedPluginDataType)
        }

        let pluginData = try dictionaryDecoder.decode(
            TokensStudioPluginData.self,
            from: rawPluginData.mapValues { $0.value }
        )

        guard let valuesData = pluginData.tokens.values.data(using: .utf8) else {
            throw TokensProviderError(code: .failedCreateData)
        }

        let json = try? JSONSerialization.jsonObject(with: valuesData, options: .mutableContainers)
        let jsonData = json.flatMap { try? JSONSerialization.data(withJSONObject: $0, options: .prettyPrinted) }

        if let jsonData {
            logger.debug(String(decoding: jsonData, as: UTF8.self))
        }

        return try jsonDecoder.decode(TokenValues.self, from: valuesData)
    }

    private func fetchFile(_ file: FileParameters) async throws -> FigmaFile {
        let route = FigmaAPIFileRoute(
            accessToken: file.accessToken,
            fileKey: file.key,
            version: file.version,
            depth: 1,
            pluginData: "shared"
        )

        return try await apiProvider
            .request(route: route)
            .async()
    }

    // MARK: -

    func fetchTokens(from file: FileParameters) async throws -> TokenValues {
        let figmaFile = try await fetchFile(file)

        return try extractTokens(from: figmaFile)
    }
}
