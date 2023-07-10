import Foundation

struct TokensGeneratorError: Error, CustomStringConvertible {

    // MARK: - Nested Types

    enum Code {
        case referenceNotFound(name: String)
        case unexpectedTokenValueType(name: String)
        case expressionFailed(expression: String)
        case invalidRGBAColorValue(rgba: String)
        case invalidAlphaComponent(alpha: String)
        case invalidHEXComponent(hex: String)
        case failedExtractLinearGradientParams(linearGradient: String)
    }

    // MARK: - Instance Properties

    let code: Code

    // MARK: - CustomStringConvertible

    var description: String {
        switch code {
        case .referenceNotFound(let name):
            return "Reference for token with name '\(name)' not found"

        case .unexpectedTokenValueType(let name):
            return "Unexpected token value type with name '\(name)'"

        case .expressionFailed(let expression):
            return "Failed to evaluate value from expression: \(expression)"

        case .invalidRGBAColorValue(let rgba):
            return "Invalid rgba() value: \(rgba)"

        case .invalidAlphaComponent(let alpha):
            return "Failed to convert alpha to float: \(alpha)"

        case .invalidHEXComponent(let hex):
            return "Invalid hex value: \(hex)"

        case .failedExtractLinearGradientParams(let linearGradient):
            return "Failed to extract linear gradient parameters: \(linearGradient)"
        }
    }
}
