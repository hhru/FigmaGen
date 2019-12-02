//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation
import PromiseKit

protocol ColorsProvider {

    // MARK: - Instance Methods

    func fetchColors(
        fileKey: String,
        includingNodes includingNodeIDs: [String]?,
        excludingNodes excludingNodeIDs: [String]?
    ) -> Promise<[Color]>
}
