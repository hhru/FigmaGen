//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

protocol TextStylesServices {

    // MARK: - Instance Methods

    func makeTextStylesProvider(accessToken: String) -> TextStylesProvider
    func makeTextStylesRenderer() -> TextStylesRenderer
}
