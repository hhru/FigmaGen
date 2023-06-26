import Foundation

struct Configuration: Decodable {

    // MARK: - Instance Properties

    let base: BaseConfiguration?

    let colorStyles: ColorStylesConfiguration?
    let textStyles: TextStylesConfiguration?
    let images: ImagesConfiguration?
    let shadowStyles: ShadowStylesConfiguration?

    // MARK: - Instance Methods

    func resolveColorStyles() -> ColorStylesConfiguration? {
        colorStyles?.resolve(base: base)
    }

    func resolveTextStyles() -> TextStylesConfiguration? {
        textStyles?.resolve(base: base)
    }

    func resolveImages() -> ImagesConfiguration? {
        images?.resolve(base: base)
    }

    func resolveShadowStyles() -> ShadowStylesConfiguration? {
        shadowStyles?.resolve(base: base)
    }
}
