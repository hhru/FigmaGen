//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

protocol ColorsServices {

    // MARK: - Instance Methods

    func makeColorsProvider(accessToken: String) -> ColorsProvider
    func makeColorsRenderer() -> ColorsRenderer
}
