import SwiftCLI

enum GradientCommandKeys {

    static let template = Key<String>(
        "--gradient-template",
        description: """
            Path to the template file.
            If no template is passed a default template will be used.
            """
    )

    static let templateOptions = VariadicKey<String>(
        "--gradient-options",
        description: """
            An option that will be merged with template context, and overwrite any values of the same name.
            Can be repeated multiple times and must be in the format: -o "name:value".
            """
    )

    static let destination = Key<String>(
        "--gradient-destination",
        description: """
            The path to the file to generate.
            By default, generated code will be printed on stdout.
            """
    )
}
