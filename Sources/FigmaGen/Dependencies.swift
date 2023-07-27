import Foundation
import FigmaGenTools

enum Dependencies {

    // MARK: - Type Properties

    static let dataProvider: DataProvider = DefaultDataProvider()

    static let figmaHTTPService: FigmaHTTPService = HTTPService()
    static let figmaAPIProvider: FigmaAPIProvider = DefaultFigmaAPIProvider(httpService: figmaHTTPService)

    static let figmaFilesProvider: FigmaFilesProvider = DefaultFigmaFilesProvider(apiProvider: figmaAPIProvider)
    static let figmaNodesProvider: FigmaNodesProvider = DefaultFigmaNodesProvider()

    static let assetsProvider: AssetsProvider = DefaultAssetsProvider()

    static let colorStyleAssetsProvider: ColorStyleAssetsProvider = DefaultColorStyleAssetsProvider(
        assetsProvider: assetsProvider
    )

    static let colorStylesProvider: ColorStylesProvider = DefaultColorStylesProvider(
        filesProvider: figmaFilesProvider,
        nodesProvider: figmaNodesProvider,
        colorStyleAssetsProvider: colorStyleAssetsProvider
    )

    static let textStylesProvider: TextStylesProvider = DefaultTextStylesProvider(
        filesProvider: figmaFilesProvider,
        nodesProvider: figmaNodesProvider
    )

    static let imageRenderProvider: ImageRenderProvider = DefaultImageRenderProvider(apiProvider: figmaAPIProvider)

    static let imageAssetsProvider: ImageAssetsProvider = DefaultImageAssetsProvider(
        assetsProvider: assetsProvider,
        dataProvider: dataProvider
    )

    static let imageResourcesProvider: ImageResourcesProvider = DefaultImageResourcesProvider(
        dataProvider: dataProvider
    )

    static let imagesProvider: ImagesProvider = DefaultImagesProvider(
        filesProvider: figmaFilesProvider,
        nodesProvider: figmaNodesProvider,
        imageRenderProvider: imageRenderProvider,
        imageAssetsProvider: imageAssetsProvider,
        imageResourcesProvider: imageResourcesProvider
    )

    static let configurationProvider: ConfigurationProvider = DefaultConfigurationProvider()

    static let shadowStylesProvider: ShadowStylesProvider = DefaultShadowStylesProvider(
        filesProvider: figmaFilesProvider,
        nodesProvider: figmaNodesProvider
    )

    static let tokensProvider: TokensProvider = DefaultTokensProvider(
        apiProvider: figmaAPIProvider
    )

    // MARK: -

    static let tokensResolver: TokensResolver = DefaultTokensResolver()

    static let tokensGenerationParametersResolver: TokensGenerationParametersResolver
        = DefaultTokensGenerationParametersResolver()

    // MARK: -

    static let templateContextCoder: TemplateContextCoder = DefaultTemplateContextCoder()

    static let stencilExtensions: [StencilExtension] = [
        StencilByteToHexFilter(),
        StencilHexToByteFilter(),
        StencilByteToFloatFilter(),
        StencilFloatToByteFilter(),
        StencilVectorInfoFilter(contextCoder: templateContextCoder),
        StencilColorRGBHexInfoFilter(contextCoder: templateContextCoder),
        StencilColorRGBAHexInfoFilter(contextCoder: templateContextCoder),
        StencilColorRGBInfoFilter(contextCoder: templateContextCoder),
        StencilColorRGBAInfoFilter(contextCoder: templateContextCoder),
        StencilColorInfoFilter(contextCoder: templateContextCoder),
        StencilFontInfoFilter(contextCoder: templateContextCoder),
        StencilFontInitializerModificator(contextCoder: templateContextCoder),
        StencilFontSystemFilter(contextCoder: templateContextCoder),
        StencilCollectionDropFirstModificator(),
        StencilCollectionDropLastModificator(),
        StencilCollectionRemovingFirstModificator(),
        StencilHexToAlphaFilter(),
        StencilFullHexModificator()
    ]

    static let templateRenderer: TemplateRenderer = DefaultTemplateRenderer(
        contextCoder: templateContextCoder,
        stencilExtensions: stencilExtensions
    )

    // MARK: -

    static let colorStylesGenerator: ColorStylesGenerator = DefaultColorStylesGenerator(
        colorStylesProvider: colorStylesProvider,
        templateRenderer: templateRenderer
    )

    static let textStylesGenerator: TextStylesGenerator = DefaultTextStylesGenerator(
        textStylesProvider: textStylesProvider,
        templateRenderer: templateRenderer
    )

    static let imagesGenerator: ImagesGenerator = DefaultImagesGenerator(
        imagesProvider: imagesProvider,
        templateRenderer: templateRenderer
    )

    static let shadowStylesGenerator: ShadowStylesGenerator = DefaultShadowStylesGenerator(
        shadowStylesProvider: shadowStylesProvider,
        templateRenderer: templateRenderer
    )

    static let colorTokensGenerator: ColorTokensGenerator = DefaultColorTokensGenerator(
        tokensResolver: tokensResolver,
        templateRenderer: templateRenderer
    )

    static let baseColorTokensGenerator: BaseColorTokensGenerator = DefaultBaseColorTokensGenerator(
        tokensResolver: tokensResolver,
        templateRenderer: templateRenderer
    )

    static let fontFamilyTokensGenerator: FontFamilyTokensGenerator = DefaultFontFamilyTokensGenerator(
        tokensResolver: tokensResolver,
        templateRenderer: templateRenderer
    )

    static let typographyTokensGenerator: TypographyTokensGenerator = DefaultTypographyTokensGenerator(
        tokensResolver: tokensResolver,
        templateRenderer: templateRenderer
    )

    static let boxShadowTokensGenerator: BoxShadowTokensGenerator = DefaultBoxShadowTokensGenerator(
        tokensResolver: tokensResolver,
        templateRenderer: templateRenderer
    )

    static let tokensGenerator: TokensGenerator = DefaultTokensGenerator(
        tokensProvider: tokensProvider,
        tokensGenerationParametersResolver: tokensGenerationParametersResolver,
        colorTokensGenerator: colorTokensGenerator,
        baseColorTokensGenerator: baseColorTokensGenerator,
        fontFamilyTokensGenerator: fontFamilyTokensGenerator,
        typographyTokensGenerator: typographyTokensGenerator,
        boxShadowTokensGenerator: boxShadowTokensGenerator
    )

    static let libraryGenerator: LibraryGenerator = DefaultLibraryGenerator(
        configurationProvider: configurationProvider,
        colorStylesGenerator: colorStylesGenerator,
        textStylesGenerator: textStylesGenerator,
        imagesGenerator: imagesGenerator,
        shadowStylesGenerator: shadowStylesGenerator,
        tokensGenerator: tokensGenerator
    )
}
