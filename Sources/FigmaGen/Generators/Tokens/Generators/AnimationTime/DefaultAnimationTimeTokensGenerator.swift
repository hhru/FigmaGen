import Foundation

struct DefaultAnimationTimeTokensGenerator: AnimationTimeTokensGenerator {

    // MARK: - Instance properties

    private let tokensResolver: TokensResolver
    private let templateRenderer: TemplateRenderer

    // MARK: - Initializers

    init(tokensResolver: TokensResolver, templateRenderer: TemplateRenderer) {
        self.tokensResolver = tokensResolver
        self.templateRenderer = templateRenderer
    }

    // MARK: - Private instance methods

    private func makeAnimationTimeToken(
        from token: TokenValue,
        tokenValues: TokenValues
    ) throws -> AnimationTime? {
        guard case .animationTime(let value) = token.type else {
            return nil
        }
        
        return AnimationTime(
            path: token.name.components(separatedBy: "."),
            duration: try tokensResolver.resolveAnimationDurationValue(
                value.duration,
                tokenValues: tokenValues,
                theme: nil
            )
        )
    }

    // MARK: - AnimationTokensGenerator

    func generate(
        renderParameters: RenderParameters,
        tokenValues: TokenValues,
        themes: [Theme],
        fallbackTheme: Theme
    ) throws {
        let coreAnimationTimes = try tokenValues.core.compactMap { value in
            try makeAnimationTimeToken(from: value, tokenValues: tokenValues)
        }

        let semanticAnimationTimes = try tokenValues.semantic.compactMap { value in
            try makeAnimationTimeToken(from: value, tokenValues: tokenValues)
        }

        try templateRenderer.renderTemplate(
            renderParameters.template,
            to: renderParameters.destination,
            context: [
                "coreAnimationTimes": coreAnimationTimes,
                "semanticAnimationTimes": semanticAnimationTimes
            ]
        )
    }
}
