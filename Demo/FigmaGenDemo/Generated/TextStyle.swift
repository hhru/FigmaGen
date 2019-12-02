// swiftlint:disable all
import Foundation
import UIKit

public struct TextStyle: Equatable {

    public let font: UIFont
    public let textColor: UIColor
    public let paragraphSpacing: CGFloat?
    public let paragraphIndent: CGFloat?
    public let lineHeight: CGFloat?
    public let letterSpacing: CGFloat?

    public var actualLineHeight: CGFloat {
        return lineHeight ?? font.lineHeight
    }

    public init(
        font: UIFont,
        textColor: UIColor,
        paragraphSpacing: CGFloat? = nil,
        paragraphIndent: CGFloat? = nil,
        lineHeight: CGFloat? = nil,
        letterSpacing: CGFloat? = nil
    ) {
        self.font = font
        self.textColor = textColor
        self.paragraphSpacing = paragraphSpacing
        self.paragraphIndent = paragraphIndent
        self.lineHeight = lineHeight
        self.letterSpacing = letterSpacing
    }

    public init(
        fontName: String,
        fontSize: CGFloat,
        textColor: UIColor,
        paragraphSpacing: CGFloat? = nil,
        paragraphIndent: CGFloat? = nil,
        lineHeight: CGFloat? = nil,
        letterSpacing: CGFloat? = nil
    ) {
        self.init(
            font: UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize),
            textColor: textColor,
            paragraphSpacing: paragraphSpacing,
            paragraphIndent: paragraphIndent,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing
        )
    }

    public func withTextColor(_ textColor: UIColor) -> TextStyle {
        return TextStyle(
            font: font,
            textColor: textColor,
            paragraphSpacing: paragraphSpacing,
            paragraphIndent: paragraphIndent,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing
        )
    }

    public func attributes(
        textColor: UIColor? = nil,
        backgroundColor: UIColor? = nil,
        alignment: NSTextAlignment? = nil,
        lineBreakMode: NSLineBreakMode? = nil,
        ignoringParagraphStyle: Bool = false
    ) -> [NSAttributedString.Key: Any] {
        var attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textColor ?? self.textColor,
        ]

        if let backgroundColor = backgroundColor {
            attributes[.backgroundColor] = backgroundColor
        }

        if let letterSpacing = letterSpacing {
            attributes[.kern] = NSNumber(value: Float(letterSpacing))
        }

        if ignoringParagraphStyle {
            return attributes
        }

        let paragraphStyle = NSMutableParagraphStyle()

        if let lineHeight = lineHeight {
            let paragraphLineSpacing = (lineHeight - font.lineHeight) / 2.0
            let paragraphLineHeight = lineHeight - paragraphLineSpacing

            paragraphStyle.lineSpacing = paragraphLineSpacing
            paragraphStyle.minimumLineHeight = paragraphLineHeight
            paragraphStyle.maximumLineHeight = paragraphLineHeight
        }

        if let paragraphSpacing = paragraphSpacing {
            paragraphStyle.paragraphSpacing = paragraphSpacing
        }

        if let paragraphIndent = paragraphIndent {
            paragraphStyle.firstLineHeadIndent = paragraphIndent
        }

        if let alignment = alignment {
            paragraphStyle.alignment = alignment
        }

        if let lineBreakMode = lineBreakMode {
            paragraphStyle.lineBreakMode = lineBreakMode
        }

        attributes[.paragraphStyle] = paragraphStyle

        return attributes
    }
}

public extension TextStyle {

    /// Body
    ///
    /// Font: SF Pro Display (SFProDisplay-Regular); weight 400.0; size 13.0
    /// Text color: Black; hex: #313033FF; rgba: 49 48 51, 100%
    /// Paragraph spacing: default
    /// Paragraph indent: default
    /// Line height: 17.0
    /// Letter spacing: -0.0
    static let body = TextStyle(
        fontName: "SFProDisplay-Regular",
        fontSize: 13.0,
        textColor: UIColor(rgbaHex: 0x313033FF),
        paragraphSpacing: nil,
        paragraphIndent: nil,
        lineHeight: 17.0,
        letterSpacing: -0.0
    )

    /// Subtitle 2
    ///
    /// Font: SF Pro Display (SFProDisplay-Regular); weight 400.0; size 11.0
    /// Text color: Black; hex: #313033FF; rgba: 49 48 51, 100%
    /// Paragraph spacing: default
    /// Paragraph indent: default
    /// Line height: 14.0
    /// Letter spacing: 0.25
    static let subtitle2 = TextStyle(
        fontName: "SFProDisplay-Regular",
        fontSize: 11.0,
        textColor: UIColor(rgbaHex: 0x313033FF),
        paragraphSpacing: nil,
        paragraphIndent: nil,
        lineHeight: 14.0,
        letterSpacing: 0.25
    )

    /// Subtitle 1
    ///
    /// Font: SF Pro Display (SFProDisplay-Bold); weight 700.0; size 13.0
    /// Text color: Black; hex: #313033FF; rgba: 49 48 51, 100%
    /// Paragraph spacing: default
    /// Paragraph indent: default
    /// Line height: 15.25
    /// Letter spacing: 0.35
    static let subtitle1 = TextStyle(
        fontName: "SFProDisplay-Bold",
        fontSize: 13.0,
        textColor: UIColor(rgbaHex: 0x313033FF),
        paragraphSpacing: nil,
        paragraphIndent: nil,
        lineHeight: 15.25,
        letterSpacing: 0.35
    )

    /// Title 2
    ///
    /// Font: SF Pro Display (SFProDisplay-Semibold); weight 600.0; size 14.0
    /// Text color: Black; hex: #313033FF; rgba: 49 48 51, 100%
    /// Paragraph spacing: default
    /// Paragraph indent: default
    /// Line height: 16.4
    /// Letter spacing: 0.0
    static let title2 = TextStyle(
        fontName: "SFProDisplay-Semibold",
        fontSize: 14.0,
        textColor: UIColor(rgbaHex: 0x313033FF),
        paragraphSpacing: nil,
        paragraphIndent: nil,
        lineHeight: 16.4,
        letterSpacing: 0.0
    )

    /// Title 1
    ///
    /// Font: SF Pro Display (SFProDisplay-Bold); weight 700.0; size 17.0
    /// Text color: Black; hex: #313033FF; rgba: 49 48 51, 100%
    /// Paragraph spacing: default
    /// Paragraph indent: default
    /// Line height: 19.9
    /// Letter spacing: 0.35
    static let title1 = TextStyle(
        fontName: "SFProDisplay-Bold",
        fontSize: 17.0,
        textColor: UIColor(rgbaHex: 0x313033FF),
        paragraphSpacing: nil,
        paragraphIndent: nil,
        lineHeight: 19.9,
        letterSpacing: 0.35
    )

    /// Large Title
    ///
    /// Font: SF Pro Display (SFProDisplay-Bold); weight 700.0; size 36.0
    /// Text color: Black; hex: #313033FF; rgba: 49 48 51, 100%
    /// Paragraph spacing: default
    /// Paragraph indent: default
    /// Line height: 40.0
    /// Letter spacing: 0.25
    static let largeTitle = TextStyle(
        fontName: "SFProDisplay-Bold",
        fontSize: 36.0,
        textColor: UIColor(rgbaHex: 0x313033FF),
        paragraphSpacing: nil,
        paragraphIndent: nil,
        lineHeight: 40.0,
        letterSpacing: 0.25
    )
}

public extension String {

    func styled(
        _ textStyle: TextStyle,
        textColor: UIColor? = nil,
        backgroundColor: UIColor? = nil,
        alignment: NSTextAlignment? = nil,
        lineBreakMode: NSLineBreakMode? = nil
    ) -> NSAttributedString {
        return NSAttributedString(
            string: self,
            attributes: textStyle.attributes(
                textColor: textColor,
                backgroundColor: backgroundColor,
                alignment: alignment,
                lineBreakMode: lineBreakMode
            )
        )
    }
}

private extension UIColor {

    convenience init(rgbaHex: UInt32) {
        self.init(
            red: CGFloat((rgbaHex >> 24) & 0xFF) / 255.0,
            green: CGFloat((rgbaHex >> 16) & 0xFF) / 255.0,
            blue: CGFloat((rgbaHex >> 8) & 0xFF) / 255.0,
            alpha: CGFloat(rgbaHex & 0xFF) / 255.0
        )
    }
}
// swiftlint:enable all
