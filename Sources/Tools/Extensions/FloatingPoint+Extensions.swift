//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

extension FloatingPoint {

    // MARK: - Instance Methods

    func rounded(precision: Int, rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> Self {
        let scale = Self(precision * 10)

        return (self * scale).rounded(rule) / scale
    }
}
