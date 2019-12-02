//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation
import PathKit

extension Path {

    // MARK: - Instance Methods

    func appending(_ path: Path) -> Path {
        return self + path
    }

    func appending(_ path: String) -> Path {
        return self + path
    }
}
