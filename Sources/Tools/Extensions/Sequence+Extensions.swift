//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

extension Sequence {

    // MARK: - Instance Properties

    var lazyFirst: Element? {
        return first { _ in true }
    }
}
