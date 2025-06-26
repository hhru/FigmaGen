import SwiftCLI

enum ColorsCommandKeys {

    static let template = Key<String>(
        "--colors-template",
        description: """
            Path to the template file.
            If no template is passed a default template will be used.
            """
    )

    static let templateOptions = VariadicKey<String>(
        "--colors-options",
        description: #"""
            An option that will be merged with template context, and overwrite any values of the same name.
            Can be repeated multiple times and must be in the format: -o "name:value".
            """#
    )

    static let destination = Key<String>(
        "--colors-destination",
        description: """
            The path to the file to generate.
            By default, generated code will be printed on stdout.
            """
    )

    static let baseColorsTemplate = Key<String>(
        "--base-colors-template",
        description: """
            Path to the template file.
            If no template is passed a default template will be used.
            """
    )

    static let baseColorsTemplateOptions = VariadicKey<String>(
        "--base-colors-options",
        description: #"""
            An option that will be merged with template context, and overwrite any values of the same name.
            Can be repeated multiple times and must be in the format: -o "name:value".
            """#
    )

    static let baseColorsDestination = Key<String>(
        "--base-colors-destination",
        description: """
            The path to the file to generate.
            By default, generated code will be printed on stdout.
            """
    )
}
