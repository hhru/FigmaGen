//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

protocol TextStylesRenderer {

    // MARK: - Instance Methods

    func renderTemplate(_ templateType: TemplateType, to destinationPath: String, textStyles: [TextStyle]) throws
}
