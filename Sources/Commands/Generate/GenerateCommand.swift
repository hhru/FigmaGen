//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation
import SwiftCLI
import PathKit
import Yams
import PromiseKit

final class GenerateCommand: Command {

    // MARK: - Nested Types

    private enum Constants {
        static let defaultConfigurationPath = ".figmagen.yml"
    }

    // MARK: - Instance Properties

    let name = "generate"
    let shortDescription = "Generates code from Figma files using a configuration file."

    let configurationPath = Key<String>(
        "--config",
        description: """
            Path to the configuration file.
            Defaults to '\(Constants.defaultConfigurationPath)'.
            """
    )

    private let services: GenerateServices

    // MARK: - Initializers

    init(services: GenerateServices) {
        self.services = services
    }

    // MARK: - Instance Methods

    func execute() throws {
        let configurationPath = Path(self.configurationPath.value ?? Constants.defaultConfigurationPath)
        let configuration = try YAMLDecoder().decode(Configuration.self, from: configurationPath.read())

        let promises = [
            generateColorsIfNeeded(configuration: configuration),
            generateTextStylesIfNeeded(configuration: configuration),
            generateSpacingsIfNeeded(configuration: configuration)
        ]

        firstly {
            when(fulfilled: promises)
        }.done {
            self.success(message: "Generation completed successfully!")
        }.catch { error in
           self.fail(error: error)
        }

        RunLoop.main.run()
    }

    private func generateColorsIfNeeded(configuration: Configuration) -> Promise<Void> {
        guard let colorsConfiguration = configuration.resolveColorsConfiguration() else {
            return .value(Void())
        }

        return ColorsGenerator(services: services).generateColors(configuration: colorsConfiguration)
    }

    private func generateTextStylesIfNeeded(configuration: Configuration) -> Promise<Void> {
        guard let textStylesConfiguration = configuration.resolveTextStylesConfiguration() else {
            return .value(Void())
        }

        return TextStylesGenerator(services: services).generateTextStyles(configuration: textStylesConfiguration)
    }

    private func generateSpacingsIfNeeded(configuration: Configuration) -> Promise<Void> {
        guard let spacingsConfiguration = configuration.resolveSpacingsConfiguration() else {
            return .value(Void())
        }

        return SpacingsGenerator(services: services).generateSpacings(configuration: spacingsConfiguration)
    }
}
