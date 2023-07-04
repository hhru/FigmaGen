// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "FigmaGen",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "figmagen", targets: ["FigmaGen"]),
        .library(name: "FigmaGenTools", targets: ["FigmaGenTools"])
    ],
    dependencies: [
        .package(url: "https://github.com/jakeheis/SwiftCLI", from: "6.0.3"),
        .package(url: "https://github.com/onevcat/Rainbow.git", from: "4.0.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.0.6"),
        .package(url: "https://github.com/kylef/PathKit.git", from: "1.0.1"),
        .package(url: "https://github.com/stencilproject/Stencil.git", from: "0.13.0"),
        .package(url: "https://github.com/SwiftGen/StencilSwiftKit.git", from: "2.7.2"),
        .package(url: "https://github.com/mxcl/PromiseKit.git", from: "8.0.0"),
        .package(url: "https://github.com/almazrafi/DictionaryCoder.git", from: "1.0.0")
    ],
    targets: [
        .binaryTarget(
            name: "SwiftLintBinary",
            url: "https://github.com/realm/SwiftLint/releases/download/0.52.2/SwiftLintBinary-macos.artifactbundle.zip",
            checksum: "89651e1c87fb62faf076ef785a5b1af7f43570b2b74c6773526e0d5114e0578e"
        ),
        .plugin(
            name: "SwiftLintXcode",
            capability: .buildTool(),
            dependencies: [
                .target(name: "SwiftLintBinary", condition: .when(platforms: [.macOS]))
            ]
        ),
        .executableTarget(
            name: "FigmaGen",
            dependencies: [
                "Yams",
                "SwiftCLI",
                "Rainbow",
                "PathKit",
                "Stencil",
                "StencilSwiftKit",
                "PromiseKit",
                "DictionaryCoder",
                "FigmaGenTools"
            ],
            path: "Sources/FigmaGen"
        ),
        .target(
            name: "FigmaGenTools",
            dependencies: [
                "SwiftCLI",
                "PathKit",
                "PromiseKit"
            ],
            path: "Sources/FigmaGenTools",
            plugins: [
                "SwiftLintXcode"
            ]
        ),
        .testTarget(
            name: "FigmaGenTests",
            dependencies: ["FigmaGen"],
            path: "Tests/FigmaGenTests"
        ),
        .testTarget(
            name: "FigmaGenToolsTests",
            dependencies: ["FigmaGenTools"],
            path: "Tests/FigmaGenToolsTests"
        )
    ],
    swiftLanguageVersions: [.v5]
)
