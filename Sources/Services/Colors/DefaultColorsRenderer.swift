//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation
import Stencil
import StencilSwiftKit
import PathKit

final class DefaultColorsRenderer {

    // MARK: - Instance Properties

    private let environment: Environment

    // MARK: - Initializers

    init() {
        let stencilExtension = Extension()

        stencilExtension.registerStencilSwiftExtensions()

        environment = Environment(
            extensions: [stencilExtension],
            templateClass: StencilSwiftTemplate.self
        )
    }

    // MARK: - Instance Methods

    private func hexComponent(from number: Double) -> String {
        return String(format: "%02lX", Int(number * 255.0))
    }

    private func makeContext(with colors: [Color]) -> [String: Any] {
        let colors = colors.map { color in
            return [
                "name": color.name,
                "red": hexComponent(from: color.red),
                "green": hexComponent(from: color.green),
                "blue": hexComponent(from: color.blue),
                "alpha": hexComponent(from: color.alpha)
            ]
        }

        return ["colors": colors]
    }
}

extension DefaultColorsRenderer: ColorsRenderer {

    // MARK: - Instance Methods

    func renderTemplate(_ templateType: TemplateType, to destinationPath: String, colors: [Color]) throws {
        let templatePath = Path(try templateType.resolvePath())
        let destinationPath = Path(destinationPath)

        let template = try StencilSwiftTemplate(
            templateString: templatePath.read(),
            environment: stencilSwiftEnvironment()
        )

        let rendered = try template.render(makeContext(with: colors))

        try destinationPath.parent().mkpath()
        try destinationPath.write(rendered, encoding: .utf8)
    }
}
