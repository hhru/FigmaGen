import Foundation
import SwiftCLI
import PathKit

#if DEBUG
Path.current = Path(#file).appending("../../../Demo")
#endif

let version = "2.0.0-beta.6"

let figmagen = CLI(
    name: "figmagen",
    version: version,
    description: "The Swift code & resources generator for your Figma files"
)

figmagen.commands = [
    ColorStylesCommand(generator: Dependencies.colorStylesGenerator),
    TextStylesCommand(generator: Dependencies.textStylesGenerator),
    ImagesCommand(generator: Dependencies.imagesGenerator),
    GenerateCommand(generator: Dependencies.libraryGenerator),
    ShadowStylesCommand(generator: Dependencies.shadowStylesGenerator),
    TokensCommand(generator: Dependencies.tokensGenerator)
]

figmagen.goAndExitOnError()
