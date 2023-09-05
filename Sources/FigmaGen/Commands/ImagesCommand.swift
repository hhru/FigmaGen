import Foundation
import SwiftCLI
import PromiseKit

final class ImagesCommand: AsyncExecutableCommand, GenerationConfigurableCommand {

    // MARK: - Instance Properties

    let generator: ImagesGenerator

    // MARK: -

    let name = "images"
    let shortDescription = "Generates code for images from a Figma file."

    let fileKey = Key<String>(
        "--fileKey",
        description: """
            Figma file key to generate images from.
            """
    )

    let fileVersion = Key<String>(
        "--fileVersion",
        description: """
            Figma file version ID to generate images from.
            """
    )

    let includedNodes = VariadicKey<String>(
        "--includingNodes",
        "-i",
        description: #"""
            A list of Figma nodes whose components will be rendered.
            Can be repeated multiple times and must be in the format: -i "1:23".
            If omitted, all nodes will be included.
            """#
    )

    let excludedNodes = VariadicKey<String>(
        "--excludingNodes",
        "-e",
        description: #"""
            A list of Figma nodes whose components will be ignored.
            Can be repeated multiple times and must be in the format: -e "1:23".
            """#
    )

    let accessToken = Key<String>(
        "--accessToken",
        description: """
            A personal access token to make requests to the Figma API.
            Get more info: https://www.figma.com/developers/api#access-tokens
            """
    )

    let assets = Key<String>(
        "--assets",
        "-a",
        description: """
            Optional path to Xcode-assets folder to store images.
            """
    )

    let resources = Key<String>(
        "--resources",
        "-r",
        description: """
            Optional path to folder to store images.
            """
    )

    let postProcessor = Key<String>(
        "--postProcessor",
        "-p",
        description: """
            The path to the bash script to make operations with generated images.
            Only executes for generated images from --resources folder.
            """
    )

    let format = Key<String>(
        "--format",
        "-f",
        description: """
            Optional image output format, can be 'pdf', 'png', 'jpg' or 'svg'.
            Defaults to 'pdf'.
            """
    )

    let scales = Key<String>(
        "-scales",
        "-s",
        description: #"""
            A comma separated list of integer image scaling factors.
            Each scaling factor should be between 1 and 3: -s "1,2,3".
            If omitted, images will be rendered with the original sizes.
            """#
    )

    let template = Key<String>(
        "--template",
        "-t",
        description: """
            Path to the template file.
            If no template is passed a default template will be used.
            """
    )

    let templateOptions = VariadicKey<String>(
        "--options",
        "-o",
        description: #"""
            An option that will be merged with template context, and overwrite any values of the same name.
            Can be repeated multiple times and must be in the format: -o "name:value".
            """#
    )

    let destination = Key<String>(
        "--destination",
        "-d",
        description: """
            The path to the file to generate.
            By default, generated code will be printed on stdout.
            """
    )

    let onlyExportables = Flag(
        "--onlyExportables",
        description: """
            Render only exportable components.
            By default, all components will be rendered.
            """
    )

    let useAbsoluteBounds = Flag(
        "--useAbsoluteBounds",
        description: """
            Use full dimensions of the node.
            By default, images will omit empty space or crop.
            """
    )

    let preserveVectorData = Flag(
        "--preserveVectorData",
        description: """
            Set preserve vector data flag in Xcode assets.
            By default, Xcode assets will be generated without vector data preserving.
            """
    )

    let groupByFrame = Flag(
        "--groupByFrame",
        description: """
            Group generated assets and resources into folders with name of parent frame.
            By default without grouping.
            """
    )

    let groupByComponentSet = Flag(
        "--groupByComponentSet",
        description: """
            Group generated assets and resources into folders with name of component set.
            Only for components with variants.
            By default without grouping.
            """
    )

    let namingStyle = Key<String>(
        "--naming-style",
        "-s",
        description: """
            Optional image output naming style, can be 'camelCase' or 'snakeCase'.
            Defaults to 'camelCase'.
            """
    )

    // MARK: - Initializers

    init(generator: ImagesGenerator) {
        self.generator = generator
    }

    // MARK: - Instance Methods

    private func resolveImageFormat() -> ImageFormat {
        switch format.value {
        case nil:
            return .pdf

        case let rawFormat?:
            guard let format = ImageFormat(rawValue: rawFormat) else {
                fail(message: "Failed to generate images: Invalid format (\(rawFormat))")
            }

            return format
        }
    }

    private func resolveImageScales() -> [ImageScale] {
        scales
            .value?
            .components(separatedBy: String.scaleSeparator)
            .map { rawScale in
                guard let scale = ImageScale(rawValue: rawScale) else {
                    fail(message: "Failed to generate images: Invalid scaling factor (\(rawScale))")
                }

                return scale
            } ?? [.none]
    }

    private func resolveNamingStyle() -> ImageNamingStyle {
        switch namingStyle.value {
        case nil:
            return .camelCase

        case let rawNamingStyle?:
            guard let format = ImageNamingStyle(rawValue: rawNamingStyle) else {
                fail(message: "Failed to generated images: Invalid naming style (\(rawNamingStyle))")
            }

            return format
        }
    }

    private func resolveImagesConfiguration() -> ImagesConfiguration {
        ImagesConfiguration(
            generatation: generationConfiguration,
            assets: assets.value,
            resources: resources.value,
            postProcessor: postProcessor.value,
            format: resolveImageFormat(),
            scales: resolveImageScales(),
            onlyExportables: onlyExportables.value,
            useAbsoluteBounds: useAbsoluteBounds.value,
            preserveVectorData: preserveVectorData.value,
            groupByFrame: groupByFrame.value,
            groupByComponentSet: groupByComponentSet.value,
            namingStyle: resolveNamingStyle()
        )
    }

    // MARK: -

    func executeAsyncAndExit() throws {
        firstly {
            self.generator.generate(configuration: self.resolveImagesConfiguration())
        }.done {
            self.succeed(message: "Images generated successfully!")
        }.catch { error in
            self.fail(message: "Failed to generate images: \(error)")
        }
    }
}

extension String {

    // MARK: - Type Properties

    fileprivate static let scaleSeparator = ","
}
