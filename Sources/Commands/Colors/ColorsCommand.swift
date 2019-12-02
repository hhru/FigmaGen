//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation
import SwiftCLI
import PromiseKit

final class ColorsCommand: Command {

    // MARK: - Instance Properties

    let name = "colors"
    let shortDescription = "Generates code for colors from a Figma file."

    let fileKey = Key<String>(
        "--fileKey",
        description: """
           Figma file key to generate colors from.
           """
    )

    let accessToken = Key<String>(
        "--accessToken",
        description: """
            A personal access token to make requests to the Figma API.
            Get more info: https://www.figma.com/developers/api#access-tokens
            """
    )

    let includingNodeIDs = Key<String>(
        "--including",
        description: """
            Comma separated list of nodes whose styles will be extracted.
            If omitted or empty, all nodes will be included.
            """
    )

    let excludingNodeIDs = Key<String>(
        "--excluding",
        description: """
            Comma separated list of nodes whose styles will be ignored.
            """
    )

    let templatePath = Key<String>(
        "--templatePath",
        "-t",
        description: """
            Path to the template file.
            If no template is passed a default template will be used.
            """
    )

    let destinationPath = Key<String>(
        "--destinationPath",
        "-d",
        description: """
            The path to the file to generate.
            Defaults to '\(ColorsGenerator.defaultDestinationPath)'.
            """
    )

    private let services: ColorsServices

    // MARK: - Initializers

    init(services: ColorsServices) {
        self.services = services
    }

    // MARK: - Instance Methods

    func execute() throws {
        let includingNodeIDs = self.includingNodeIDs.value?.components(separatedBy: ",") ?? []
        let excludingNodeIDs = self.excludingNodeIDs.value?.components(separatedBy: ",") ?? []

        let configuration = StepConfiguration(
            fileKey: fileKey.value,
            accessToken: accessToken.value,
            includingNodes: includingNodeIDs,
            excludingNodes: excludingNodeIDs,
            templatePath: templatePath.value,
            destinationPath: destinationPath.value
        )

        let generator = ColorsGenerator(services: services)

        firstly {
            generator.generateColors(configuration: configuration)
        }.done {
            self.success(message: "Color generation completed successfully!")
        }.catch { error in
            self.fail(error: error)
        }

        RunLoop.main.run()
    }
}
