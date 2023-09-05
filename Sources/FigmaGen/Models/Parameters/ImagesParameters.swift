import Foundation

struct ImagesParameters {

    // MARK: - Instance Properties

    let format: ImageFormat
    let scales: [ImageScale]
    let assets: String?
    let resources: String?
    let postProcessor: String?
    let onlyExportables: Bool
    let useAbsoluteBounds: Bool
    let preserveVectorData: Bool
    let groupByFrame: Bool
    let groupByComponentSet: Bool
    let namingStyle: ImageNamingStyle
}
