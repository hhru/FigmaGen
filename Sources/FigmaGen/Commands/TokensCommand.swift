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

    let remoteFileOwnerKey = Key<String>(
        "--remoteFileOwner",
        description: """
            Remote Repo owner key to generate text styles from.
            """
    )

    let remoteFileRepoKey = Key<String>(
        "--remoteFileRepo",
        description: """
            Remote Repo key to generate text styles from.
            """
    )

    let remoteFileBranchKey = Key<String>(
        "--remoteFileBranch",
        description: """
            Remote Repo branch to generate text styles from.
            """
    )

    let remoteFilePathKey = Key<String>(
        "--remoteFilePath",
        description: """
            Remote Repo file key to generate text styles from.
            """
    )

    let remoteRepoAccessTokenKey = Key<String>(
        "--remoteRepoAccessToken",
        description: """
            Remote Repo personal access token to make requests to the GitHub.
            """
    )

    let accessToken = Key<String>(
        "--accessToken",
        description: """
            A personal access token to make requests to the Figma API.
            Get more info: https://www.figma.com/developers/api#access-tokens
            """
    )

    let themes = VariadicKey<String>(
        "--themes",
        description: """
            An option that will be merged with template context.
            """
    )

    let fallbackTheme = Key<String>(
        "--fallbackTheme",
        description: """
            the default theme used when the requested theme is unavailable. Must be one of the values listed in themes.
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

    let baseColorsTemplate = Key<String>(
        "--base-colors-template",
        description: """
            Path to the template file.
            If no template is passed a default template will be used.
            """
    )

    let baseColorsTemplateOptions = VariadicKey<String>(
        "--base-colors-options",
        description: #"""
            An option that will be merged with template context, and overwrite any values of the same name.
            Can be repeated multiple times and must be in the format: -o "name:value".
            """#
    )

    let baseColorsDestination = Key<String>(
        "--base-colors-destination",
        description: """
            The path to the file to generate.
            By default, generated code will be printed on stdout.
            """
    )

    let fontFamiliesTemplate = Key<String>(
        "--font-families-template",
        description: """
            Path to the template file.
            If no template is passed a default template will be used.
            """
    )

    let fontFamiliesTemplateOptions = VariadicKey<String>(
        "--font-families-options",
        description: #"""
            An option that will be merged with template context, and overwrite any values of the same name.
            Can be repeated multiple times and must be in the format: -o "name:value".
            """#
    )

    let fontFamiliesDestination = Key<String>(
        "--font-families-destination",
        description: """
            The path to the file to generate.
            By default, generated code will be printed on stdout.
            """
    )

    let typographiesTemplate = Key<String>(
        "--typographies-template",
        description: """
            Path to the template file.
            If no template is passed a default template will be used.
            """
    )

    let typographiesTemplateOptions = VariadicKey<String>(
        "--typographies-options",
        description: #"""
            An option that will be merged with template context, and overwrite any values of the same name.
            Can be repeated multiple times and must be in the format: -o "name:value".
            """#
    )

    let typographiesDestination = Key<String>(
        "--typographies-destination",
        description: """
            The path to the file to generate.
            By default, generated code will be printed on stdout.
            """
    )

    let boxShadowsTemplate = Key<String>(
        "--box-shadows-template",
        description: """
            Path to the template file.
            If no template is passed a default template will be used.
            """
    )

    let boxShadowsTemplateOptions = VariadicKey<String>(
        "--box-shadows-options",
        description: #"""
            An option that will be merged with template context, and overwrite any values of the same name.
            Can be repeated multiple times and must be in the format: -o "name:value".
            """#
    )

    let boxShadowsDestination = Key<String>(
        "--box-shadows-destination",
        description: """
            The path to the file to generate.
            By default, generated code will be printed on stdout.
            """
    )

    let themeTemplate = Key<String>(
        "--theme-template",
        description: """
            Path to the template file.
            If no template is passed a default template will be used.
            """
    )

    let themeTemplateOptions = VariadicKey<String>(
        "--theme-options",
        description: #"""
            An option that will be merged with template context, and overwrite any values of the same name.
            Can be repeated multiple times and must be in the format: -o "name:value".
            """#
    )

    let themeDestination = Key<String>(
        "--theme-destination",
        description: """
            The path to the file to generate.
            By default, generated code will be printed on stdout.
            """
    )

    let spacingTemplate = Key<String>(
        "--spacing-template",
        description: """
            Path to the template file.
            If no template is passed a default template will be used.
            """
    )

    let spacingTemplateOptions = VariadicKey<String>(
        "--spacing-options",
        description: #"""
             An option that will be merged with template context, and overwrite any values of the same name.
             Can be repeated multiple times and must be in the format: -o "name:value".
             """#
    )

    let spacingDestination = Key<String>(
        "--spacing-destination",
        description: """
             The path to the file to generate.
             By default, generated code will be printed on stdout.
             """
    )

    let bordersTemplate = Key<String>(
        "--borders-template",
        description: """
        Path to the template file.
        If no template is passed a default template will be used.
        """
    )

    let bordersTemplateOptions = VariadicKey<String>(
        "--borders-options",
        description: """
            An option that will be merged with template context, and overwrite any values of the same name.
            Can be repeated multiple times and must be in the format: -o "name:value".
            """
    )

    let bordersDestination = Key<String>(
        "--borders-destination",
        description: """
            The path to the file to generate.
            By default, generated code will be printed on stdout.
            """
    )

    let gradientTemplate = Key<String>(
        "--gradient-template",
        description: """
        Path to the template file.
        If no template is passed a default template will be used.
        """
    )

    let gradientTemplateOptions = VariadicKey<String>(
        "--gradient-options",
        description: """
            An option that will be merged with template context, and overwrite any values of the same name.
            Can be repeated multiple times and must be in the format: -o "name:value".
            """
    )

    let gradientDestination = Key<String>(
        "--gradient-destination",
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

    // !!! Important note !!!
    // For CLI usage of FigmaGen we don't support multiple templates for any token type.
    var configuration: TokensConfiguration {
        TokensConfiguration(
            file: resolveFileConfiguration(),
            remoteRepoConfig: resolveRemoteRepoConfiguration(),
            accessToken: resolveAccessTokenConfiguration(),
            themesConfiguration: resolveTokenThemesConfiguration(),
            templates: TokensTemplateConfiguration(
                colors: [
                    TemplateConfiguration(
                        template: colorsTemplate.value,
                        templateOptions: resolveTemplateOptions(colorsTemplateOptions.value),
                        destination: colorsDestination.value
                    )
                ],
                baseColors: [
                    TemplateConfiguration(
                        template: baseColorsTemplate.value,
                        templateOptions: resolveTemplateOptions(baseColorsTemplateOptions.value),
                        destination: baseColorsDestination.value
                    )
                ],
                fontFamilies: [
                    TemplateConfiguration(
                        template: fontFamiliesTemplate.value,
                        templateOptions: resolveTemplateOptions(fontFamiliesTemplateOptions.value),
                        destination: fontFamiliesDestination.value
                    )
                ],
                typographies: [
                    TemplateConfiguration(
                        template: typographiesTemplate.value,
                        templateOptions: resolveTemplateOptions(typographiesTemplateOptions.value),
                        destination: typographiesDestination.value
                    )
                ],
                boxShadows: [
                    TemplateConfiguration(
                        template: boxShadowsTemplate.value,
                        templateOptions: resolveTemplateOptions(boxShadowsTemplateOptions.value),
                        destination: boxShadowsDestination.value
                    )
                ],
                theme: [
                    TemplateConfiguration(
                        template: themeTemplate.value,
                        templateOptions: resolveTemplateOptions(themeTemplateOptions.value),
                        destination: themeDestination.value
                    )
                ],
                spacing: [
                    TemplateConfiguration(
                        template: spacingTemplate.value,
                        templateOptions: resolveTemplateOptions(spacingTemplateOptions.value),
                        destination: spacingDestination.value
                    )
                ],
                borders: [
                    TemplateConfiguration(
                        template: bordersTemplate.value,
                        templateOptions: resolveTemplateOptions(bordersTemplateOptions.value),
                        destination: bordersDestination.value
                    )
                ],
                gradients: [
                    TemplateConfiguration(
                        template: gradientTemplate.value,
                        templateOptions: resolveTemplateOptions(gradientTemplateOptions.value),
                        destination: gradientDestination.value
                    )
                ]
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

    private func resolveRemoteRepoConfiguration() -> RemoteRepoConfiguration? {
        guard
            let fileOwner = remoteFileOwnerKey.value,
            let fileRepo = remoteFileRepoKey.value,
            let fileBranch = remoteFileBranchKey.value,
            let filePath = remoteFilePathKey.value,
            let remoteRepoAccessToken = remoteRepoAccessTokenKey.value
        else {
            return nil
        }

        return RemoteRepoConfiguration(
            owner: fileOwner,
            repo: fileRepo,
            branch: fileBranch,
            filePath: filePath,
            accessToken: AccessTokenConfiguration(value: remoteRepoAccessToken)
        )
    }

    private func resolveAccessTokenConfiguration() -> AccessTokenConfiguration? {
        guard let accessToken = accessToken.value else {
            return nil
        }

        return AccessTokenConfiguration(value: accessToken)
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

    private func resolveTokenThemesConfiguration() -> TokenThemesConfiguration? {
        let themes = themes.value
        let fallbackTheme = fallbackTheme.value

        guard let fallbackTheme, !themes.isEmpty else {
            return nil
        }

        return TokenThemesConfiguration(
            themes: themes.map { Theme($0) },
            fallbackTheme: Theme(fallbackTheme)
        )
    }
}
