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
            .compactMap(\.self)
            .filter { $0 > 0}
            .min()

        guard let t else {
            // Невозможно вычислить пересечение с границей
            return nil
        }

        let endPoint = CGPoint(x: 0.5 + t * ucos, y: 0.5 + t * usin)
        let startPoint = CGPoint(x: 0.5 - t * ucos, y: 0.5 - t * usin)

        return (start: startPoint, end: endPoint)
    }

    private func resolveThemeValue(
        from gradient: LinearGradient,
        tokenName: String
    ) -> LinearGradientToken.GradientThemeValue? {
        guard let points = resolvePoints(angle: gradient.radians) else {
            return nil
        }

        return LinearGradientToken.GradientThemeValue(
            stops: gradient.colorStopList.compactMap { stop in
                let percentage = stop.percentage.replacingOccurrences(of: "%", with: "")
                guard let percentage = Double(percentage) else {
                    return nil
                }

                return .init(
                    color: stop.color.hexString,
                    percentage: percentage
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

    private func resolveGradientToken(
        tokenName: String,
        fallbackColorToken: LinearGradientToken.GradientThemeValue,
        tokenValues: TokenValues,
        theme: Theme
    ) throws -> LinearGradientToken.GradientThemeValue {
        let themeData: (tokenValues: [TokenValue], warningPrefix: String)
        switch theme {
        case .night:
            themeData = (tokenValues.hhNight, "Night")

        case .zpDay:
            themeData = (tokenValues.zpDay, "ZpDay")

        case .day, .undefined:
            themeData = ([], "")
        }

        guard let themeToken = themeData.tokenValues.first(where: { $0.name == tokenName }) else {
            return fallbackColorToken
        }

        guard case .color(let themeValue) = themeToken.type else {
            return fallbackColorToken
        }

        let gradient = try tokensResolver.resolveLinearGradientValue(
            themeValue,
            tokenValues: tokenValues,
            theme: theme
        )

        return resolveThemeValue(from: gradient, tokenName: tokenName) ?? fallbackColorToken
    }

    private func createGradientToken(
        _ gradientValue: String,
        tokenName: String,
        path: [String],
        tokenValues: TokenValues
    ) throws -> LinearGradientToken? {
        let dayGradient = try tokensResolver.resolveLinearGradientValue(
            gradientValue,
            tokenValues: tokenValues,
            theme: .day
        )

        guard let dayToken = resolveThemeValue(from: dayGradient, tokenName: tokenName) else {
            return nil
        }

        let nightToken = try resolveGradientToken(
            tokenName: tokenName,
            fallbackColorToken: dayToken,
            tokenValues: tokenValues,
            theme: .night
        )

        let zpDayToken = try resolveGradientToken(
            tokenName: tokenName,
            fallbackColorToken: dayToken,
            tokenValues: tokenValues,
            theme: .zpDay
        )

        return LinearGradientToken(
            path: path,
            name: tokenName,
            dayTheme: dayToken,
            nightTheme: nightToken,
            zpDayTheme: zpDayToken
        )
    }

    // TODO: @mi.fedorov поддержать мульти-темы
    private func extractGradientToken(
        from token: TokenValue,
        tokenValues: TokenValues
    ) throws -> LinearGradientToken? {
        let path = token.name.components(separatedBy: ".")

        guard
            case .color(let dayValue) = token.type,
            dayValue.contains("gradient"),
            path[0] != "color"
        else {
            return nil
        }

        return try createGradientToken(
            dayValue,
            tokenName: token.name,
            path: path,
            tokenValues: tokenValues
        )
    }

    // MARK: - GradientTokensContextProvider

    func extractTokenContext(from tokenValues: TokenValues) throws -> [String : Any] {
        let gradient = try tokenValues.hhDay.compactMap {
            try extractGradientToken(from: $0, tokenValues: tokenValues)
        }

        return structure(tokens: gradient, contextName: "gradients")
    }
}
