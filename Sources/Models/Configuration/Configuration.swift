//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

struct Configuration: Decodable {

    // MARK: - Instance Properties

    let base: BaseConfiguration?

    let colors: StepConfiguration?
    let textStyles: StepConfiguration?

    // MARK: - Instance Methods

    func resolveColorsConfiguration() -> StepConfiguration? {
        return colors?.resolve(baseConfiguration: base)
    }

    func resolveTextStylesConfiguration() -> StepConfiguration? {
        return textStyles?.resolve(baseConfiguration: base)
    }
}
