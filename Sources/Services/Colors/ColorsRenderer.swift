//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

protocol ColorsRenderer {

    // MARK: - Instance Methods

    func renderTemplate(_ templateType: TemplateType, to destinationPath: String, colors: [Color]) throws
}
