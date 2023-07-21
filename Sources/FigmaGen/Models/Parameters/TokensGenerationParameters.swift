import Foundation

struct TokensGenerationParameters {

    // MARK: - Nested Types

    struct TokensParameters {

        // MARK: - Instance Properties

        let colorRender: RenderParameters
        let baseColorRender: RenderParameters
        let fontFamilyRender: RenderParameters
    }

    // MARK: - Instance Properties

    let file: FileParameters
    let tokens: TokensParameters
}
