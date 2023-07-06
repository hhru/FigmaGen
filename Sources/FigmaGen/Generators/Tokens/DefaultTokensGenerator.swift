import Foundation
import FigmaGenTools
import Expression

final class DefaultTokensGenerator: TokensGenerator, GenerationParametersResolving {

    // MARK: - Instance Properties

    let tokensProvider: TokensProvider

    let defaultTemplateType = RenderTemplateType.native(name: "Tokens")
    let defaultDestination = RenderDestination.console

    // MARK: - Initializers

    init(tokensProvider: TokensProvider) {
        self.tokensProvider = tokensProvider
    }

    // MARK: - Instance Methods

    private func evaluteValue(_ value: String) -> String {
        let expression = Expression(value)

        do {
            return try String(expression.evaluate())
        } catch {
            return value
        }
    }

    private func resolveValue(_ value: String, tokenValues: TokenValues) throws -> String {
        let allTokens = tokenValues.all
        let referenceStart = "{"
        let referenceEnd = "}"

        let scanner = Scanner(string: value)

        var value = value
        var referenceRanges: [(String, Range<String.Index>)] = []

        while !scanner.isAtEnd {
            _ = scanner.scanUpToString(referenceStart)
            let startIndex = scanner.currentIndex
            _ = scanner.scanString(referenceStart)
            let referenceName = scanner.scanUpToString(referenceEnd)
            _ = scanner.scanString(referenceEnd)

            guard let referenceName else {
                continue
            }

            guard let token = allTokens.first(where: { $0.name == referenceName }) else {
                throw TokensGeneratorError(code: .referenceNotFound(name: referenceName))
            }

            guard let value = token.type.stringValue else {
                throw TokensGeneratorError(code: .unexpectedTokenValueType(name: referenceName))
            }

            referenceRanges.append(
                (try resolveValue(value, tokenValues: tokenValues), startIndex..<scanner.currentIndex)
            )
        }

        referenceRanges
            .reversed()
            .forEach { value.replaceSubrange($1, with: $0) }

        return evaluteValue(value)
    }

    private func generate(parameters: GenerationParameters) async throws {
        let tokenValues = try await tokensProvider.fetchTokens(from: parameters.file)

        try tokenValues.all
            .compactMap { tokenValue -> (TokenValue, String)? in
                guard let value = tokenValue.type.stringValue else {
                    return nil
                }

                return (tokenValue, try resolveValue(value, tokenValues: tokenValues))
            }
            .forEach { tokenValue, value in
                print("[\(tokenValue.name)] \(value)")
            }

        // PORTFOLIO-22826 Генерация основных токенов
    }

    // MARK: -

    func generate(configuration: TokensConfiguration) async throws {
        let parameters = try await Task.detached(priority: .userInitiated) {
            try self.resolveGenerationParameters(from: configuration)
        }.value

        try await generate(parameters: parameters)
    }
}
