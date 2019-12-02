//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation
import PromiseKit

protocol TextStylesProvider {

    // MARK: - Instance Methods

    func fetchTextStyles(
        fileKey: String,
        includingNodes includingNodeIDs: [String]?,
        excludingNodes excludingNodeIDs: [String]?
    ) -> Promise<[TextStyle]>
}
