import Foundation

struct DefaultGradientTokensContextProvider: ColorTokensContextProvider {

    let tokensResolver: TokensResolver

    init(tokensResolver: TokensResolver) {
        self.tokensResolver = tokensResolver
    }

    // MARK: - Private methods

    private func resolvePoints(angle: CGFloat) -> (start: CGPoint, end: CGPoint)? {
        let start = 3.0 * .pi / 2
        let u = start + angle

        let ucos = cos(u)
        let usin = sin(u)

        let xedge = ucos > 0 ? 1.0 : 0
        let yedge = usin > 0 ? 1.0 : 0

        let tx = ucos == 0 ? nil : (xedge - 0.5) / ucos
        let ty = usin == 0 ? nil : (yedge - 0.5) / usin

        let t = [tx, ty]
            .compactMap { $0 }
            .filter { $0 > 0.0 }
            .min()

        guard let t else {
            // Невозможно вычислить пересечение с границей
            return nil
        }

        let endPoint = CGPoint(
            x: round((0.5 + t * ucos) * 1000) / 1000,
            y: round((0.5 + t * usin) * 1000) / 1000
        )
        let startPoint = CGPoint(
            x: round((0.5 - t * ucos) * 1000) / 1000,
            y: round((0.5 - t * usin) * 1000) / 1000
        )

        return (start: startPoint, end: endPoint)
    }

    private func resolveGradientToken(
        for token: TokenValue,
        theme: Theme,
        values: TokenValues
    ) throws -> LinearGradientToken? {
        let tokens = values.tokens(for: theme)

        guard let themeToken = tokens.first(where: { $0.name == token.name }) else {
            return nil
        }

        guard case .color(let themeValue) = themeToken.type else {
            return nil
        }

        let gradient = try tokensResolver.resolveLinearGradientValue(
            themeValue,
            tokenValues: values,
            theme: theme
        )

        let path = token.name.components(separatedBy: ".")

        guard let points = resolvePoints(angle: gradient.radians) else {
            throw DefaultGradientTokensContextProviderError.invalidAngle(token.name)
        }

        return LinearGradientToken(
            path: path,
            name: token.name,
            stops: gradient.colorStopList.compactMap { stop in
                let percentage = stop.percentage.replacingOccurrences(of: "%", with: "")
                guard let percentage = Double(percentage) else {
                    return nil
                }

                return .init(
                    color: stop.color.hexString,
                    percentage: percentage / 100
                )
            },
            startPoint: LinearGradientToken.Point(
                x: points.start.x,
                y: points.start.y
            ),
            endPoint: LinearGradientToken.Point(
                x: points.end.x,
                y: points.end.y
            )
        )
    }

    private func makeGradientToken(
        from token: TokenValue,
        tokenValues: TokenValues,
        theme: Theme,
        fallbackTheme: Theme
    ) throws -> LinearGradientToken? {
        let path = token.name.components(separatedBy: ".")

        guard
            case .color(let fallbackTokenValue) = token.type,
            fallbackTokenValue.contains("gradient"),
            path.first != "color"
        else {
            return nil
        }

        let fallbackToken = try resolveGradientToken(for: token, theme: fallbackTheme, values: tokenValues)
        let resolvedToken = try resolveGradientToken(for: token, theme: theme, values: tokenValues)

        guard let fallbackToken else {
            logger.warning("Fallback token not found for \(token.name)", isVerbose: true)
            return nil
        }

        if resolvedToken.isNil {
            logger.warning(
                "\(theme.name) value for token '\(token.name)' not found, using \(fallbackTheme.name)",
                isVerbose: true
            )
        }

        return resolvedToken ?? fallbackToken
    }

    // MARK: - GradientTokensContextProvider

    func extractTokenContext(
        from tokenValues: TokenValues,
        themes: [Theme],
        fallbackTheme: Theme
    ) throws -> [TokenThemeValue<[String: Any]>] {
        return try themes.map { theme in
            let gradients = try tokenValues
                .tokens(for: fallbackTheme)
                .compactMap { token in
                    try makeGradientToken(
                        from: token,
                        tokenValues: tokenValues,
                        theme: theme,
                        fallbackTheme: fallbackTheme
                    )
                }

            return TokenThemeValue(
                theme: theme.name,
                value: structure(tokens: gradients, contextName: "gradients")
            )
        }
    }
}
