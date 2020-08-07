//
// FigmaGen
// Copyright © 2020 HeadHunter
// MIT Licence
//

import Foundation
import StencilSwiftKit
import PathKit

final class DefaultSpacingsRenderer {

    // MARK: - Instance Methods

    private func makeContext(with spacings: [Spacing]) -> [String: Any] {
        let spacings = spacings.map { spacing in
            return [
                "name": spacing.name,
                "value": spacing.value
            ]
        }
        return ["spacings": spacings]
    }
}

extension DefaultSpacingsRenderer: SpacingsRenderer {

    // MARK: - Instance Methods

    func renderTemplate(_ templateType: TemplateType, to destinationPath: String, spacings: [Spacing]) throws {
        let templatePath = Path(try templateType.resolvePath())
        let destinationPath = Path(destinationPath)

        let template = try StencilSwiftTemplate(
            templateString: templatePath.read(),
            environment: stencilSwiftEnvironment()
        )

        let rendered = try template.render(makeContext(with: spacings))

        try destinationPath.parent().mkpath()
        try destinationPath.write(rendered, encoding: .utf8)
    }
}
