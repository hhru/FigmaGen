//
// FigmaGen
// Copyright © 2020 HeadHunter
// MIT Licence
//

import Foundation

protocol SpacingsRenderer {

    // MARK: - Instance Methods

    func renderTemplate(_ templateType: TemplateType, to destinationPath: String, spacings: [Spacing]) throws
}
