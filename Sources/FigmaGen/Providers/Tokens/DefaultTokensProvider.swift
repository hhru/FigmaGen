import Foundation
import DictionaryCoder

final class DefaultTokensProvider: TokensProvider {

    // MARK: - Instance Properties

    let figmaApiProvider: FigmaAPIProvider
    let gitHubApiProvider: RemoteRepoProvider

    let dictionaryDecoder = DictionaryDecoder()
    let jsonDecoder = JSONDecoder()

    // MARK: - Initializers

    init(figmaApiProvider: FigmaAPIProvider, gitHubApiProvider: RemoteRepoProvider) {
        self.figmaApiProvider = figmaApiProvider
        self.gitHubApiProvider = gitHubApiProvider
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

        return try await figmaApiProvider
            .request(route: route)
            .async()
    }

    private func fetchRemoteFile<Response: Decodable>(
        _ filePath: String,
        from remoteFile: RemoteFileParameters
    ) async throws -> Response {
        let route = GitHubAPIFileRoute<Response>(
            owner: remoteFile.owner,
            repo: remoteFile.repo,
            branch: remoteFile.branch,
            filePath: filePath,
            accessToken: remoteFile.accessToken
        )

        return try await gitHubApiProvider
            .request(route: route)
            .async()
    }

    private func fetchManifest(from remoteFile: RemoteFileParameters) async throws -> SXLTokensManifest {
        let manifest: SXLTokensManifest = try await fetchRemoteFile(remoteFile.filePath, from: remoteFile)

        guard manifest.schema == SXLTokensManifest.schema else {
            throw TokensProviderError(code: .unsupportedManifestSchema(schema: manifest.schema ?? "nil"))
        }

        return manifest
    }

    private func fetchTokensFiles(
        of manifest: SXLTokensManifest,
        from remoteFile: RemoteFileParameters
    ) async throws -> [String: W3CTokenJSON] {
        let manifestDirectory = (remoteFile.filePath as NSString).deletingLastPathComponent

        let filePaths = Set(
            manifest.collections
                .filter { remoteFile.includeDisabled || $0.isEnabled }
                .flatMap { $0.modes }
                .filter { remoteFile.includeDisabled || $0.isEnabled }
                .flatMap { remoteFile.includeDisabled ? $0.allFiles : $0.enabledFiles }
        )

        return try await withThrowingTaskGroup(of: (path: String, json: W3CTokenJSON).self) { group in
            for filePath in filePaths {
                group.addTask {
                    let fullPath = (manifestDirectory as NSString).appendingPathComponent(filePath)
                    let file: W3CTokenJSON = try await self.fetchRemoteFile(fullPath, from: remoteFile)

                    return (path: filePath, json: file)
                }
            }

            return try await group.reduce(into: [:]) { files, file in
                files[file.path] = file.json
            }
        }
    }

    // MARK: -

    func fetchTokens(from file: FileParameters) async throws -> TokenValues {
        let figmaFile = try await fetchFile(file)

        return try extractTokens(from: figmaFile)
    }

    func fetchTokens(from remoteFile: RemoteFileParameters) async throws -> TokenValues {
        let manifest = try await fetchManifest(from: remoteFile)
        let files = try await fetchTokensFiles(of: manifest, from: remoteFile)

        return try W3CTokensNormalizer(includeDisabled: remoteFile.includeDisabled).normalize(
            manifest: manifest,
            files: files,
            mapping: remoteFile.tokenSets
        )
    }
}
