import Foundation

struct DefaultAnimationEaseTokensGenerator: AnimationEaseTokensGenerator {

    // MARK: - Instance properties

    private let tokensResolver: TokensResolver
    private let templateRenderer: TemplateRenderer

    // MARK: - Initializers

    init(tokensResolver: TokensResolver, templateRenderer: TemplateRenderer) {
        self.tokensResolver = tokensResolver
        self.templateRenderer = templateRenderer
    }

    // MARK: - Private instance methods

    private func makeAnimationEaseToken(
        from token: TokenValue,
        tokenValues: TokenValues
    ) throws -> AnimationEase? {
        if case .animationEaseBase(let value) = token.type {
            return AnimationEase(
                base: AnimationEase.Base(
                    path: token.name.components(separatedBy: "."),
                    x1: value.x1,
                    y1: value.y1,
                    x2: value.x2,
                    y2: value.y2
                ),
                spring: nil
            )
        } else if case .animationEaseSpring(let value) = token.type {
            return AnimationEase(
                base: nil,
                spring: AnimationEase.Spring(
                    path: token.name.components(separatedBy: "."),
                    stiffness: value.stiffness,
                    damping: value.damping,
                    mass: value.mass
                )
            )
        } else {
            return nil
        }
    }

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
            ),
            durationMs: value.duration
        )
    }

    // MARK: - AnimationTokensGenerator

    func generate(
        renderParameters: RenderParameters,
        tokenValues: TokenValues,
        themes: [Theme],
        fallbackTheme: Theme
    ) throws {
        let timesCore = try tokenValues.core.compactMap { value in
            try makeAnimationTimeToken(from: value, tokenValues: tokenValues)
        }
        let timesSemantic = try tokenValues.semantic.compactMap { value in
            try makeAnimationTimeToken(from: value, tokenValues: tokenValues)
        }

        let coreAnimationEase = try tokenValues.core.compactMap { value in
            try makeAnimationEaseToken(from: value, tokenValues: tokenValues)
        }
        let coreAnimationEaseBase = coreAnimationEase.compactMap { $0.base }
        let coreAnimationEaseSpring = coreAnimationEase.compactMap { $0.spring }

        let semanticAnimationEase = try tokenValues.semantic.compactMap { value in
            try makeAnimationEaseToken(from: value, tokenValues: tokenValues)
        }
        let semanticAnimationEaseBase = semanticAnimationEase.compactMap { $0.base }
        let semanticAnimationEaseSpring = semanticAnimationEase.compactMap { $0.spring }

        let all = coreAnimationEase + semanticAnimationEase

        try templateRenderer.renderTemplate(
            renderParameters.template,
            to: renderParameters.destination,
            context: [
                "allAnimations": all,
                "animationTimesCore": timesCore,
                "animationTimesSemantic": timesSemantic,
                "coreAnimationEaseBase": coreAnimationEaseBase,
                "coreAnimationEaseSpring": coreAnimationEaseSpring,
                "semanticAnimationEaseBase": semanticAnimationEaseBase,
                "semanticAnimationEaseSpring": semanticAnimationEaseSpring
            ]
        )
    }
}
