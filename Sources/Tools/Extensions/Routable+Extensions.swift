//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation
import SwiftCLI

#if canImport(RainbowSwift)
import RainbowSwift
#else
import Rainbow
#endif

extension Routable {

    // MARK: - Instance Methods

    func fail(message: String) -> Never {
        stderr <<< message.red

        exit(EXIT_FAILURE)
    }

    func fail(error: Error) -> Never {
        fail(message: "Failed with error: \(error)")
    }

    func success(message: String? = nil) -> Never {
        if let message = message {
            stdout <<< message.green
        }

        exit(EXIT_SUCCESS)
    }
}
