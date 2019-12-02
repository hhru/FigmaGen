//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation
import SwiftCLI

let services = Services()

let figmaGen = CLI(
    name: "figmagen",
    version: "1.0.0",
    description: "A tool to automate resources using the Figma API."
)

figmaGen.commands = [
    ColorsCommand(services: services),
    TextStylesCommand(services: services),
    GenerateCommand(services: services)
]

figmaGen.goAndExitOnError()
