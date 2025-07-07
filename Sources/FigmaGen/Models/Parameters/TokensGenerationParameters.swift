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
        let gradientsRenderParameters: [RenderParameters]?
        let animationTimesRenderParameters: [RenderParameters]?
        let animationEasesRenderParameters: [RenderParameters]?
    }

    // MARK: - Instance Properties

    let file: FileParameters?
    let remoteFile: RemoteFileParameters?
    let themes: [Theme]
    let fallbackTheme: Theme
    let tokens: TokensParameters
}
