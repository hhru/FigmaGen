import Foundation

struct ImagesConfiguration: Decodable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case assets
        case resources
        case postProcessor
        case format
        case scales
        case onlyExportables
        case useAbsoluteBounds
        case preserveVectorData
        case renderAs
        case groupByFrame
        case groupByComponentSet
        case namingStyle
    }

    // MARK: - Instance Properties

    let generatation: GenerationConfiguration
    let assets: String?
    let resources: String?
    let postProcessor: String?
    let format: ImageFormat
    let scales: [ImageScale]
    let onlyExportables: Bool
    let useAbsoluteBounds: Bool
    let preserveVectorData: Bool
    let renderAs: ImageRenderingMode?
    let groupByFrame: Bool
    let groupByComponentSet: Bool
    let namingStyle: ImageNamingStyle

    // MARK: - Initializers

    init(
        generatation: GenerationConfiguration,
        assets: String?,
        resources: String?,
        postProcessor: String?,
        format: ImageFormat,
        scales: [ImageScale],
        onlyExportables: Bool,
        useAbsoluteBounds: Bool,
        preserveVectorData: Bool,
        renderAs: ImageRenderingMode?,
        groupByFrame: Bool,
        groupByComponentSet: Bool,
        namingStyle: ImageNamingStyle
    ) {
        self.generatation = generatation
        self.assets = assets
        self.resources = resources
        self.postProcessor = postProcessor
        self.format = format
        self.scales = scales
        self.onlyExportables = onlyExportables
        self.useAbsoluteBounds = useAbsoluteBounds
        self.preserveVectorData = preserveVectorData
        self.renderAs = renderAs
        self.groupByFrame = groupByFrame
        self.groupByComponentSet = groupByComponentSet
        self.namingStyle = namingStyle
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        assets = try container.decodeIfPresent(forKey: .assets)
        resources = try container.decodeIfPresent(forKey: .resources)

        postProcessor = try container.decodeIfPresent(forKey: .postProcessor)
        format = try container.decodeIfPresent(forKey: .format) ?? .pdf
        scales = try container.decodeIfPresent(forKey: .scales) ?? [.none]
        onlyExportables = try container.decodeIfPresent(forKey: .onlyExportables) ?? false
        useAbsoluteBounds = try container.decodeIfPresent(forKey: .useAbsoluteBounds) ?? false
        preserveVectorData = try container.decodeIfPresent(forKey: .preserveVectorData) ?? false
        renderAs = try container.decodeIfPresent(forKey: .renderAs)
        groupByFrame = try container.decodeIfPresent(forKey: .groupByFrame) ?? false
        groupByComponentSet = try container.decodeIfPresent(forKey: .groupByComponentSet) ?? false
        namingStyle = try container.decodeIfPresent(forKey: .namingStyle) ?? .camelCase

        generatation = try GenerationConfiguration(from: decoder)
    }

    // MARK: - Instance Methods

    func resolve(base: BaseConfiguration?) -> Self {
        Self(
            generatation: generatation.resolve(base: base),
            assets: assets,
            resources: resources,
            postProcessor: postProcessor,
            format: format,
            scales: scales,
            onlyExportables: onlyExportables,
            useAbsoluteBounds: useAbsoluteBounds,
            preserveVectorData: preserveVectorData,
            renderAs: renderAs,
            groupByFrame: groupByFrame,
            groupByComponentSet: groupByComponentSet,
            namingStyle: namingStyle
        )
    }
}
