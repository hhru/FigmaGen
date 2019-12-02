//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

extension ProcessInfo {

    // MARK: - Instance Properties

    var executablePath: String {
        return arguments[0]
    }
}
