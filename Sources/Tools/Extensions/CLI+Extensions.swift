//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation
import SwiftCLI

extension CLI {

    // MARK: - Instance Methods

    func goAndExitOnError() {
        let result = go()

        if result != EXIT_SUCCESS {
            exit(result)
        }
    }
}
