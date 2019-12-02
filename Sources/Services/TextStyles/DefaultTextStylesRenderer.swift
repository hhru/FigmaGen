//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation
import Stencil
import StencilSwiftKit
import PathKit

final class DefaultTextStylesRenderer {

    // MARK: - Instance Properties

    private let stencilEnvironment: Environment

    // MARK: - Initializers

    init() {
        let stencilExtension = Extension()

        stencilExtension.registerStencilSwiftExtensions()

        stencilEnvironment = Environment(
            extensions: [stencilExtension],
            templateClass: StencilSwiftTemplate.self
        )
    }

    // MARK: - Instance Methods

    private func mapColorComponent(_ colorComponent: Double) -> String {
        return String(format: "%02lX", Int(colorComponent * 255.0))
    }

    private func mapColor(_ color: Color) -> [String: Any] {
        var dictionary: [String: Any] = [
            "red": mapColorComponent(color.red),
            "green": mapColorComponent(color.green),
            "blue": mapColorComponent(color.blue),
            "alpha": mapColorComponent(color.alpha)
        ]

        if let colorName = color.name {
            dictionary["name"] = colorName
        }

        return dictionary
    }

    private func mapTextStyle(_ textStyle: TextStyle) -> [String: Any] {
        var dictionary: [String: Any] = [
            "name": textStyle.name,
            "fontFamily": textStyle.fontFamily,
            "fontPostScriptName": textStyle.fontPostScriptName,
            "fontWeight": "\(textStyle.fontWeight)",
            "fontSize": "\(textStyle.fontSize)",
            "textColor": mapColor(textStyle.textColor)
        ]

        if let paragraphSpacing = textStyle.paragraphSpacing {
            dictionary["paragraphSpacing"] = "\(paragraphSpacing.rounded(precision: 2))"
        }

        if let paragraphIndent = textStyle.paragraphIndent {
            dictionary["paragraphIndent"] = "\(paragraphIndent.rounded(precision: 2))"
        }

        if let lineHeight = textStyle.lineHeight {
            dictionary["lineHeight"] = "\(lineHeight.rounded(precision: 2))"
        }

        if let letterSpacing = textStyle.letterSpacing {
            dictionary["letterSpacing"] = "\(letterSpacing.rounded(precision: 2))"
        }

        return dictionary
    }

    private func makeContext(with textStyles: [TextStyle]) -> [String: Any] {
        return ["textStyles": textStyles.map(mapTextStyle)]
    }
}

extension DefaultTextStylesRenderer: TextStylesRenderer {

    // MARK: - Instance Methods

    func renderTemplate(_ templateType: TemplateType, to destinationPath: String, textStyles: [TextStyle]) throws {
        let templatePath = Path(try templateType.resolvePath())
        let destinationPath = Path(destinationPath)

        let template = try StencilSwiftTemplate(
            templateString: templatePath.read(),
            environment: stencilEnvironment
        )

        let output = try template.render(makeContext(with: textStyles))

        try destinationPath.parent().mkpath()
        try destinationPath.write(output)
    }
}
