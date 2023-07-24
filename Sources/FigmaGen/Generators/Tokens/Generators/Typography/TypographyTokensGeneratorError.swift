import Foundation

struct TypographyTokensGeneratorError: Error, CustomStringConvertible {

    // MARK: - Nested Types

    enum Code {
        case failedExtractFontSize(value: String)
        case failedExtractLetterSpacing(value: String)
    }

    // MARK: - Instance Properties

    let code: Code

    // MARK: - CustomStringConvertible

    var description: String {
        switch code {
        case .failedExtractFontSize(let value):
            return "Failed to extract font size from value: \(value)"

        case .failedExtractLetterSpacing(let value):
            return "Failed to extract letter spacing from value: \(value)"
        }
    }
}
