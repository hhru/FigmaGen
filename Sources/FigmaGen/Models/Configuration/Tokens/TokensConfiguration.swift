import Foundation

struct TokensConfiguration: Decodable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case templates
    }

    // MARK: - Instance Properties

    let file: FileConfiguration?
    let accessToken: AccessTokenConfiguration?
    let templates: TokensTemplateConfiguration?

    // MARK: - Initializers

    init(from decoder: Decoder) throws {
        let base = try BaseConfiguration(from: decoder)

        self.file = base.file
        self.accessToken = base.accessToken

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.templates = try container.decodeIfPresent(forKey: .templates)
    }

    init(
        file: FileConfiguration?,
        accessToken: AccessTokenConfiguration?,
        templates: TokensTemplateConfiguration?
    ) {
        self.file = file
        self.accessToken = accessToken
        self.templates = templates
    }
}
