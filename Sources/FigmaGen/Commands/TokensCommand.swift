import SwiftCLI

final class TokensCommand: AsyncExecutableCommand {

    // MARK: - Instance Properties

    let generator: TokensGenerator

    // MARK: -

    let name = "tokens"
    let shortDescription = "Generates code for tokens from a Figma file."

    let fileKey = FigmaCommandKeys.fileKey
    let fileVersion = FigmaCommandKeys.fileVersion
    let accessToken = FigmaCommandKeys.accessToken

    let remoteFileOwnerKey = GitHubRemoteFileCommandKeys.ownerKey
    let remoteFileRepoKey = GitHubRemoteFileCommandKeys.repoKey
    let remoteFileBranchKey = GitHubRemoteFileCommandKeys.branchKey
    let remoteFilePathKey = GitHubRemoteFileCommandKeys.pathKey
    let remoteRepoAccessTokenKey = GitHubRemoteFileCommandKeys.repoAccessTokenKey

    let themes = ThemeCommandKeys.themes
    let fallbackTheme = ThemeCommandKeys.fallbackTheme
    let themeTemplate = ThemeCommandKeys.themeTemplate
    let themeTemplateOptions = ThemeCommandKeys.themeTemplateOptions
    let themeDestination = ThemeCommandKeys.themeDestination

    let colorsTemplate = ColorsCommandKeys.template
    let colorsTemplateOptions = ColorsCommandKeys.templateOptions
    let colorsDestination = ColorsCommandKeys.destination

    let baseColorsTemplate = ColorsCommandKeys.baseColorsTemplate
    let baseColorsTemplateOptions = ColorsCommandKeys.baseColorsTemplateOptions
    let baseColorsDestination = ColorsCommandKeys.baseColorsDestination

    let fontFamiliesTemplate = FontFamiliesCommandKeys.template
    let fontFamiliesTemplateOptions = FontFamiliesCommandKeys.templateOptions
    let fontFamiliesDestination = FontFamiliesCommandKeys.destination

    let typographiesTemplate = TypographiesCommandKeys.template
    let typographiesTemplateOptions = TypographiesCommandKeys.templateOptions
    let typographiesDestination = TypographiesCommandKeys.destination

    let boxShadowsTemplate = BoxShadowsCommandKeys.template
    let boxShadowsTemplateOptions = BoxShadowsCommandKeys.templateOptions
    let boxShadowsDestination = BoxShadowsCommandKeys.destination

    let spacingTemplate = SpacingCommandKeys.template
    let spacingTemplateOptions = SpacingCommandKeys.templateOptions
    let spacingDestination = SpacingCommandKeys.destination

    let bordersTemplate = BordersCommandKeys.template
    let bordersTemplateOptions = BordersCommandKeys.templateOptions
    let bordersDestination = BordersCommandKeys.destination

    let borderRadiusesTemplate = BordersRadiusCommandKeys.template
    let borderRadiusesTemplateOptions = BordersRadiusCommandKeys.templateOptions
    let borderRadiusesDestination = BordersRadiusCommandKeys.destination

    let gradientTemplate = GradientCommandKeys.template
    let gradientTemplateOptions = GradientCommandKeys.templateOptions
    let gradientDestination = GradientCommandKeys.destination

    let animationTimeTemplate = AnimationTimeCommandKeys.template
    let animationTimeTemplateOptions = AnimationTimeCommandKeys.templateOptions
    let animationTimeDestination = AnimationTimeCommandKeys.destination

    let animationEaseTemplate = AnimationEaseCommandKeys.template
    let animationEaseTemplateOptions = AnimationEaseCommandKeys.templateOptions
    let animationEaseDestination = AnimationEaseCommandKeys.destination

    let blurTemplate = BlurCommandKeys.template
    let blurTemplateOptions = BlurCommandKeys.templateOptions
    let blurDestination = BlurCommandKeys.destination

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
                borderRadiuses: [
                    TemplateConfiguration(
                        template: borderRadiusesTemplate.value,
                        templateOptions: resolveTemplateOptions(borderRadiusesTemplateOptions.value),
                        destination: borderRadiusesDestination.value
                    )
                ],
                gradients: [
                    TemplateConfiguration(
                        template: gradientTemplate.value,
                        templateOptions: resolveTemplateOptions(gradientTemplateOptions.value),
                        destination: gradientDestination.value
                    )
                ],
                animationTimes: [
                    TemplateConfiguration(
                        template: animationTimeTemplate.value,
                        templateOptions: resolveTemplateOptions(animationTimeTemplateOptions.value),
                        destination: animationTimeDestination.value
                    )
                ],
                animationEases: [
                    TemplateConfiguration(
                        template: animationEaseTemplate.value,
                        templateOptions: resolveTemplateOptions(animationEaseTemplateOptions.value),
                        destination: animationEaseDestination.value
                    )
                ],
                blur: [
                    TemplateConfiguration(
                        template: blurTemplate.value,
                        templateOptions: resolveTemplateOptions(blurTemplateOptions.value),
                        destination: blurDestination.value
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
