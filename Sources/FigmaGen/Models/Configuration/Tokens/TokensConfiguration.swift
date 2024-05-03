import Foundation

struct TokensConfiguration: Decodable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case templates
    }

    // MARK: - Instance Properties

    let file: FileConfiguration?
    let remoteRepoConfig: RemoteRepoConfiguration?
    let accessToken: AccessTokenConfiguration?
    let templates: TokensTemplateConfiguration?

    // MARK: - Initializers

    init(from decoder: Decoder) throws {
        let base = try BaseConfiguration(from: decoder)

        self.file = base.file
        self.accessToken = base.accessToken
        self.remoteRepoConfig = base.remoteRepoConfig

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.templates = try container.decodeIfPresent(forKey: .templates)
    }

    init(
        file: FileConfiguration?,
        remoteRepoConfig: RemoteRepoConfiguration?,
        accessToken: AccessTokenConfiguration?,
        templates: TokensTemplateConfiguration?
    ) {
        self.file = file
        self.remoteRepoConfig = remoteRepoConfig
        self.accessToken = accessToken
        self.templates = templates
    }

    // MARK: - Instance Methods

    func resolve(base: BaseConfiguration?) -> Self {
        guard let base else {
            return self
        }

        return Self(
            file: file ?? base.file,
            remoteRepoConfig: remoteRepoConfig ?? base.remoteRepoConfig,
            accessToken: accessToken ?? base.accessToken,
            templates: templates
        )
    }
}
