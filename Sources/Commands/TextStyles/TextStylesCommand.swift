//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation
import SwiftCLI
import PromiseKit

final class TextStylesCommand: Command {

    // MARK: - Instance Properties

    let name = "textStyles"
    let shortDescription = "Generates code for text styles from a Figma file."

    let fileKey = Key<String>(
        "--fileKey",
        description: """
           Figma file key to generate text styles from.
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
            Defaults to '\(TextStylesGenerator.defaultDestinationPath)'.
            """
    )

    private let services: TextStylesServices

    // MARK: - Initializers

    init(services: TextStylesServices) {
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
            templatePath: self.templatePath.value,
            destinationPath: self.destinationPath.value
        )

        let generator = TextStylesGenerator(services: services)

        firstly {
            generator.generateTextStyles(configuration: configuration)
        }.done {
            self.success(message: "Text styles generation completed successfully!")
        }.catch { error in
            self.fail(error: error)
        }

        RunLoop.main.run()
    }
}
