// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "FigmaGen",
    platforms: [
       .macOS(.v10_12)
    ],
    products: [
        .executable(
            name: "figmagen",
            targets: ["FigmaGen"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/jakeheis/SwiftCLI", from: "5.0.0"),
        .package(url: "https://github.com/onevcat/Rainbow.git", from: "3.0.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "2.0.0"),
        .package(url: "https://github.com/kylef/PathKit.git", from: "0.9.2"),
        .package(url: "https://github.com/kylef/Stencil.git", from: "0.13.0"),
        .package(url: "https://github.com/SwiftGen/StencilSwiftKit.git", from: "2.7.2"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.0.0-rc.2"),
        .package(url: "https://github.com/mxcl/PromiseKit.git", from: "6.8.0")
    ],
    targets: [
        .target(
            name: "FigmaGen",
            dependencies: [
                "SwiftCLI",
                "Rainbow",
                "Yams",
                "PathKit",
                "Stencil",
                "StencilSwiftKit",
                "Alamofire",
                "PromiseKit"
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "FigmaGenTests",
            dependencies: ["FigmaGen"],
            path: "Tests"
        )
    ]
)
