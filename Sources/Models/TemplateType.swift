//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation
import PathKit

enum TemplateType {

    // MARK: - Nested Types

    private enum Constants {
        static let bundleTemplates = "Templates"
        static let podsTemplates = "../Templates"
        static let shareTemplates = "../../share/figmagen"
    }

    // MARK: - Enumeration Cases

    case native(name: String)
    case custom(path: String)

    // MARK: - Instance Methods

    func resolvePath() throws -> String {
        switch self {
        case let .native(name: templateName):
            let bundle = Bundle(for: BundleToken.self)

            if let bundleTemplatesPath = bundle.path(forResource: Constants.bundleTemplates, ofType: nil) {
                return Path(bundleTemplatesPath).appending(templateName).string
            }

            var executablePath = Path(ProcessInfo.processInfo.executablePath)

            while executablePath.isSymlink {
                executablePath = try executablePath.symlinkDestination()
            }

            let podsTemplatesPath = executablePath.appending(Constants.podsTemplates)

            if podsTemplatesPath.exists {
                return podsTemplatesPath.appending(templateName).string
            }

            return executablePath
                .appending(Constants.shareTemplates)
                .appending(templateName)
                .string

        case let .custom(path: templatePath):
            return templatePath
        }
    }
}

private final class BundleToken {}
