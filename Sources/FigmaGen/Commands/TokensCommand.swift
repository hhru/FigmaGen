import SwiftCLI

final class TokensCommand: AsyncExecutableCommand {

    // MARK: - Instance Properties

    let generator: TokensGenerator

    // MARK: -

    let name = "tokens"
    let shortDescription = "Generates code for tokens from a Figma file."

    let fileKey = Key<String>(
        "--fileKey",
        description: """
            Figma file key to generate text styles from.
            """
    )

    let fileVersion = Key<String>(
        "--fileVersion",
        description: """
            Figma file version ID to generate color styles from.
            """
    )

    let accessToken = Key<String>(
        "--accessToken",
        description: """
            A personal access token to make requests to the Figma API.
            Get more info: https://www.figma.com/developers/api#access-tokens
            """
    )

    let colorsTemplate = Key<String>(
        "--colors-template",
        description: """
            Path to the template file.
            If no template is passed a default template will be used.
            """
    )

    let colorsTemplateOptions = VariadicKey<String>(
        "--colors-options",
        description: #"""
            An option that will be merged with template context, and overwrite any values of the same name.
            Can be repeated multiple times and must be in the format: -o "name:value".
            """#
    )

    let colorsDestination = Key<String>(
        "--colors-destination",
        description: """
            The path to the file to generate.
            By default, generated code will be printed on stdout.
            """
    )

    // MARK: - Initializers

    init(generator: TokensGenerator) {
        self.generator = generator
    }

    // MARK: - Instance Methods

    func executeAsyncAndExit() async throws {
        do {
            try await generator.generate(configuration: configuration)
            succeed(message: "Tokens generated successfully!")
        } catch {
            fail(message: "Failed to generate tokens: \(error)")
        }
    }
}

extension TokensCommand {

    // MARK: - Instance Properties

    var configuration: TokensConfiguration {
        TokensConfiguration(
            file: resolveFileConfiguration(),
            accessToken: resolveAccessTokenConfiguration(),
            templates: TokensTemplateConfiguration(
                color: TokensTemplateConfiguration.Template(
                    template: colorsTemplate.value,
                    templateOptions: resolveTemplateOptions(colorsTemplateOptions.value),
                    destination: colorsDestination.value
                )
            )
        )
    }

    // MARK: - Instance Methods

    private func resolveFileConfiguration() -> FileConfiguration? {
        guard let fileKey = fileKey.value else {
            return nil
        }

        return FileConfiguration(
            key: fileKey,
            version: fileVersion.value,
            includedNodes: nil,
            excludedNodes: nil
        )
    }

    private func resolveAccessTokenConfiguration() -> AccessTokenConfiguration? {
        guard let accessToken = accessToken.value else {
            return nil
        }

        return .value(accessToken)
    }

    private func resolveTemplateOptions(_ templateOptionsValues: [String]) -> [String: Any] {
        var templateOptions: [String: String] = [:]

        for templateOption in templateOptionsValues {
            var optionComponents = templateOption.components(separatedBy: String.templateOptionSeparator)
            let optionKey = optionComponents.removeFirst().trimmingCharacters(in: .whitespaces)
            let optionValue = optionComponents.joined(separator: .templateOptionSeparator)

            templateOptions[optionKey] = optionValue
        }

        return templateOptions
    }
}
