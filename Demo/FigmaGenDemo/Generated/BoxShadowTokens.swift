// swiftlint:disable all
// Generated using FigmaGen - https://github.com/hhru/FigmaGen
#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

public struct BoxShadowTokens {

    /// - hh-day:
    /// Offset: x 0; y 4
    /// Radius: 12
    /// Color: #7090b029
    /// - hh-night:
    /// Offset: x 0; y 4
    /// Radius: 12
    /// Color: #7090b029
    public let level1: ShadowToken

    /// - hh-day:
    /// Offset: x 0; y 8
    /// Radius: 16
    /// Color: #7090b03d
    /// - hh-night:
    /// Offset: x 0; y 8
    /// Radius: 16
    /// Color: #7090b03d
    public let level2: ShadowToken

    /// - hh-day:
    /// Offset: x 0; y 12
    /// Radius: 24
    /// Color: #7090b052
    /// - hh-night:
    /// Offset: x 0; y 12
    /// Radius: 24
    /// Color: #7090b052
    public let level3: ShadowToken
}

public struct ShadowToken: Equatable {

    // MARK: - Instance Properties

    public let offset: CGSize
    public let radius: CGFloat
    public let color: UIColor?
    public let opacity: Float

    // MARK: - Initializers

    public init(
        offset: CGSize = CGSize(width: 0, height: -3),
        radius: CGFloat = 3.0,
        color: UIColor? = .black,
        opacity: Float = 0.0
    ) {
        self.offset = offset
        self.radius = radius
        self.color = color
        self.opacity = opacity
    }
}

public extension CALayer {

    // MARK: - Instance Properties

    var shadowToken: ShadowToken {
        get {
            ShadowToken(
                offset: shadowOffset,
                radius: shadowRadius,
                color: shadowColor.map(UIColor.init(cgColor:)),
                opacity: shadowOpacity
            )
        }

        set {
            shadowOffset = newValue.offset
            shadowRadius = newValue.radius
            shadowColor = newValue.color?.cgColor
            shadowOpacity = newValue.opacity
        }
    }

    // MARK: - Initializers

    convenience init(shadowToken: ShadowToken) {
        self.init()

        self.shadowToken = shadowToken
    }
}

public extension UIView {

    // MARK: - Instance Properties

    var shadowToken: ShadowToken {
        get { layer.shadowToken }
        set { layer.shadowToken = newValue }
    }
}
