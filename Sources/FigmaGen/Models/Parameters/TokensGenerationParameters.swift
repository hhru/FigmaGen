import Foundation

struct TokensGenerationParameters {

    // MARK: - Nested Types

    struct TokensParameters {

        // MARK: - Instance Properties

        let colorRenderParameters: [RenderParameters]?
        let baseColorRenderParameters: [RenderParameters]?
        let fontFamilyRenderParameters: [RenderParameters]?
        let typographyRenderParameters: [RenderParameters]?
        let boxShadowRenderParameters: [RenderParameters]?
        let themeRenderParameters: [RenderParameters]?
        let spacingRenderParameters: [RenderParameters]?
        let bordersRenderParameters: [RenderParameters]?
        let gradientRenderParameters: [RenderParameters]?
    }

    // MARK: - Instance Properties

    let file: FileParameters?
    let remoteFile: RemoteFileParameters?
    let tokens: TokensParameters
}
