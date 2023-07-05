import Foundation

struct TokensGeneratorError: Error, CustomStringConvertible {

    // MARK: - Nested Types

    enum Code {
        case referenceNotFound(name: String)
        case unexpectedTokenValueType(name: String)
        case expressionFailed(expression: String)
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
        }
    }
}
