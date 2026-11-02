import SwiftCLI

enum GitHubRemoteFileCommandKeys {

    static let ownerKey = Key<String>(
        "--remoteFileOwner",
        description: """
            Remote Repo owner key to generate text styles from.
            """
    )

    static let repoKey = Key<String>(
        "--remoteFileRepo",
        description: """
            Remote Repo key to generate text styles from.
            """
    )

    static let branchKey = Key<String>(
        "--remoteFileBranch",
        description: """
            Remote Repo branch to generate text styles from.
            """
    )

    static let pathKey = Key<String>(
        "--remoteFilePath",
        description: """
            Remote Repo file key to generate text styles from.
            """
    )

    static let repoAccessTokenKey = Key<String>(
        "--remoteRepoAccessToken",
        description: """
            Remote Repo personal access token to make requests to the GitHub.
            """
    )

    static let tokenSetCoreKey = Key<String>(
        "--tokenSetCore",
        description: """
            Manifest collection with core tokens.
            """
    )

    static let tokenSetSemanticKey = Key<String>(
        "--tokenSetSemantic",
        description: """
            Manifest collection with semantic tokens.
            """
    )

    static let tokenSetColorsKey = Key<String>(
        "--tokenSetColors",
        description: """
            Manifest collection with base colors.
            """
    )

    static let tokenSetTypographyKey = Key<String>(
        "--tokenSetTypography",
        description: """
            Manifest collection with typography tokens.
            """
    )

    static let tokenSetThemesKey = Key<String>(
        "--tokenSetThemes",
        description: """
            Manifest collection whose modes are themes.
            """
    )
}
