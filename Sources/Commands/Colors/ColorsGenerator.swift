//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation
import PromiseKit

final class ColorsGenerator {

    // MARK: - Type Properties

    static let defaultDestinationPath = "Generated/Colors.swift"
    static let defaultTemplateName = "Colors.stencil"

    // MARK: - Instance Properties

    private let services: ColorsServices

    // MARK: - Initializers

    init(services: ColorsServices) {
        self.services = services
    }

    // MARK: - Instance Methods

    func generateColors(configuration: StepConfiguration) -> Promise<Void> {
        guard let fileKey = configuration.fileKey, !fileKey.isEmpty else {
            return Promise(error: ConfigurationError.invalidFileKey)
        }

        guard let accessToken = configuration.accessToken, !accessToken.isEmpty else {
            return Promise(error: ConfigurationError.invalidAccessToken)
        }

        let templateType = resolveTemplateType(configuration: configuration)
        let destinationPath = resolveDestinationPath(configuration: configuration)

        let colorsProvider = services.makeColorsProvider(accessToken: accessToken)
        let colorsRenderer = services.makeColorsRenderer()

        return firstly {
            colorsProvider.fetchColors(
                fileKey: fileKey,
                includingNodes: configuration.includingNodes,
                excludingNodes: configuration.excludingNodes
            )
        }.map { colors in
            try colorsRenderer.renderTemplate(
                templateType,
                to: destinationPath,
                colors: colors
            )
        }
    }

    private func resolveTemplateType(configuration: StepConfiguration) -> TemplateType {
        if let templatePath = configuration.templatePath {
            return .custom(path: templatePath)
        } else {
            return .native(name: Self.defaultTemplateName)
        }
    }

    private func resolveDestinationPath(configuration: StepConfiguration) -> String {
        return configuration.destinationPath ?? Self.defaultDestinationPath
    }
}
