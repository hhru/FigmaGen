// swiftlint:disable all
// Generated using FigmaGen - https://github.com/hhru/FigmaGen

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

public struct Theme {

    public let colors: ColorTokens
    public let shadows: BoxShadowTokens
    public let typographies: TypographyTokens

    init(
        colors: ColorTokens,
        shadows: BoxShadowTokens,
        typographies: TypographyTokens = TypographyTokens()
    ) {
        self.colors = colors
        self.shadows = shadows
        self.typographies = typographies
    }
}

extension Theme {

    public static let defaultLight = Self(
        colors: ColorTokens(
            accent: ColorTokens.Accent(
                bg: UIColor(hex: 0xC3DAFEFF),
                default: UIColor(hex: 0x7F9CF5FF),
                onAccent: UIColor(hex: 0xFFFFFFFF)
            ),
            bg: ColorTokens.Bg(
                default: UIColor(hex: 0xFFFFFFFF),
                muted: UIColor(hex: 0xF7FAFCFF),
                subtle: UIColor(hex: 0xEDF2F7FF)
            ),
            fg: ColorTokens.Fg(
                default: UIColor(hex: 0x000000FF),
                muted: UIColor(hex: 0x4A5568FF),
                subtle: UIColor(hex: 0xA0AEC0FF)
            ),
            shadows: ColorTokens.Shadows(
                default: UIColor(hex: 0x1A202CFF)
            )
        ),
        shadows: BoxShadowTokens(
            level1: ShadowToken(
                offset: CGSize(width: 0, height: 4),
                radius: 12,
                color: UIColor(hex: 0x7090B029),
                opacity: 1.0
            ),
            level2: ShadowToken(
                offset: CGSize(width: 0, height: 8),
                radius: 16,
                color: UIColor(hex: 0x7090B03D),
                opacity: 1.0
            ),
            level3: ShadowToken(
                offset: CGSize(width: 0, height: 12),
                radius: 24,
                color: UIColor(hex: 0x7090B052),
                opacity: 1.0
            )
        )
    )

    public static let defaultDark = Self(
        colors: ColorTokens(
            accent: ColorTokens.Accent(
                bg: UIColor(hex: 0x434190FF),
                default: UIColor(hex: 0x5A67D8FF),
                onAccent: UIColor(hex: 0xFFFFFFFF)
            ),
            bg: ColorTokens.Bg(
                default: UIColor(hex: 0x1A202CFF),
                muted: UIColor(hex: 0x4A5568FF),
                subtle: UIColor(hex: 0x718096FF)
            ),
            fg: ColorTokens.Fg(
                default: UIColor(hex: 0xFFFFFFFF),
                muted: UIColor(hex: 0xE2E8F0FF),
                subtle: UIColor(hex: 0xA0AEC0FF)
            ),
            shadows: ColorTokens.Shadows(
                default: UIColor(hex: 0x00000000)
            )
        ),
        shadows: BoxShadowTokens(
            level1: ShadowToken(
                offset: CGSize(width: 0, height: 4),
                radius: 12,
                color: UIColor(hex: 0x7090B029),
                opacity: 1.0
            ),
            level2: ShadowToken(
                offset: CGSize(width: 0, height: 8),
                radius: 16,
                color: UIColor(hex: 0x7090B03D),
                opacity: 1.0
            ),
            level3: ShadowToken(
                offset: CGSize(width: 0, height: 12),
                radius: 24,
                color: UIColor(hex: 0x7090B052),
                opacity: 1.0
            )
        )
    )
}

private extension UIColor {

    convenience init(hex: UInt32) {
        let red = UInt8((hex >> 24) & 0xFF)
        let green = UInt8((hex >> 16) & 0xFF)
        let blue = UInt8((hex >> 8) & 0xFF)
        let alpha = UInt8(hex & 0xFF)

        self.init(
            red: CGFloat(red) / 255.0, 
            green: CGFloat(green) / 255.0, 
            blue: CGFloat(blue) / 255.0, 
            alpha: CGFloat(alpha) / 255.0
        )
    }
}
