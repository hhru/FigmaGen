import SwiftCLI

enum ThemeCommandKeys {

    static let themes = VariadicKey<String>(
        "--themes",
        description: """
            An option that will be merged with template context.
            """
    )

    static let fallbackTheme = Key<String>(
        "--fallbackTheme",
        description: """
            the default theme used when the requested theme is unavailable. Must be one of the values listed in themes.
            """
    )

    static let themeTemplate = Key<String>(
        "--theme-template",
        description: """
            Path to the template file.
            If no template is passed a default template will be used.
            """
    )

    static let themeTemplateOptions = VariadicKey<String>(
        "--theme-options",
        description: #"""
            An option that will be merged with template context, and overwrite any values of the same name.
            Can be repeated multiple times and must be in the format: -o "name:value".
            """#
    )

    static let themeDestination = Key<String>(
        "--theme-destination",
        description: """
            The path to the file to generate.
            By default, generated code will be printed on stdout.
            """
    )
}
