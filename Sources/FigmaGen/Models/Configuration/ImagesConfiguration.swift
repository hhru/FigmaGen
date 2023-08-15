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
        case groupByFrame
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
    let groupByFrame: Bool

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
        groupByFrame: Bool
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
        self.groupByFrame = groupByFrame
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
        groupByFrame = try container.decodeIfPresent(forKey: .groupByFrame) ?? false

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
            groupByFrame: groupByFrame
        )
    }
}
