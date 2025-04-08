import Foundation

struct TokensConfiguration: Decodable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case templates
        case remoteRepoConfig
    }

    // MARK: - Instance Properties

    let file: FileConfiguration?
    let remoteRepoConfig: RemoteRepoConfiguration?
    let accessToken: AccessTokenConfiguration?
    let themesConfiguration: TokenThemesConfiguration?
    let templates: TokensTemplateConfiguration?

    // MARK: - Initializers

    init(from decoder: Decoder) throws {
        let base = try BaseConfiguration(from: decoder)

        self.file = base.file
        self.accessToken = base.accessToken

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.remoteRepoConfig = try container.decodeIfPresent(forKey: .remoteRepoConfig)
        self.templates = try container.decodeIfPresent(forKey: .templates)
        self.themesConfiguration = try TokenThemesConfiguration(from: decoder)
    }

    init(
        file: FileConfiguration?,
        remoteRepoConfig: RemoteRepoConfiguration?,
        accessToken: AccessTokenConfiguration?,
        themesConfiguration: TokenThemesConfiguration?,
        templates: TokensTemplateConfiguration?
    ) {
        self.file = file
        self.remoteRepoConfig = remoteRepoConfig
        self.accessToken = accessToken
        self.themesConfiguration = themesConfiguration
        self.templates = templates
    }

    // MARK: - Instance Methods

    func resolve(base: BaseConfiguration?) -> Self {
        guard let base else {
            return self
        }

        return Self(
            file: file ?? base.file,
            remoteRepoConfig: remoteRepoConfig,
            accessToken: accessToken ?? base.accessToken,
            themesConfiguration: themesConfiguration,
            templates: templates
        )
    }
}
