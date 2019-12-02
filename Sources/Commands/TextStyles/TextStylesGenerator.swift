//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation
import PromiseKit

final class TextStylesGenerator {

    // MARK: - Type Properties

    static let defaultTemplateName = "TextStyles.stencil"
    static let defaultDestinationPath = "Generated/TextStyles.swift"

    // MARK: - Instance Properties

    private let services: TextStylesServices

    // MARK: - Initializers

    init(services: TextStylesServices) {
        self.services = services
    }

    // MARK: - Instance Methods

    func generateTextStyles(configuration: StepConfiguration) -> Promise<Void> {
        guard let fileKey = configuration.fileKey, !fileKey.isEmpty else {
            return Promise(error: ConfigurationError.invalidFileKey)
        }

        guard let accessToken = configuration.accessToken, !accessToken.isEmpty else {
            return Promise(error: ConfigurationError.invalidAccessToken)
        }

        let templateType = resolveTemplateType(configuration: configuration)
        let destinationPath = resolveDestinationPath(configuration: configuration)

        let textStylesProvider = services.makeTextStylesProvider(accessToken: accessToken)
        let textStylesRenderer = services.makeTextStylesRenderer()

        return firstly {
            textStylesProvider.fetchTextStyles(
                fileKey: fileKey,
                includingNodes: configuration.includingNodes,
                excludingNodes: configuration.excludingNodes
            )
        }.map { textStyles in
            try textStylesRenderer.renderTemplate(
                templateType,
                to: destinationPath,
                textStyles: textStyles
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
