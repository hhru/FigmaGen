// swiftlint:disable all
// Generated using FigmaGen - https://github.com/hhru/FigmaGen

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

public struct TypographyTokens {

    /// typography H1 Bold
    ///
    /// Font: Inter Bold
    /// Strikethrough: false
    /// Underline: false
    /// Paragraph spacing: 32
    /// Paragraph indent: default
    /// Line height: 53.71
    /// Letter spacing: -2.44
    public let typographyH1Bold = Typography(
        font: UIFont(name: "Inter-Bold", size: 48.828125),
        color: .label,
        strikethrough: false,
        underline: false,
        paragraphSpacing: 32,
        paragraphIndent: nil,
        lineHeight: 53.71,
        letterSpacing: -2.44
    )

    /// typography H1 Regular
    ///
    /// Font: Inter Regular
    /// Strikethrough: false
    /// Underline: false
    /// Paragraph spacing: 32
    /// Paragraph indent: default
    /// Line height: 53.71
    /// Letter spacing: -2.44
    public let typographyH1Regular = Typography(
        font: UIFont(name: "Inter-Regular", size: 48.828125),
        color: .label,
        strikethrough: false,
        underline: false,
        paragraphSpacing: 32,
        paragraphIndent: nil,
        lineHeight: 53.71,
        letterSpacing: -2.44
    )

    /// typography H2 Bold
    ///
    /// Font: Inter Bold
    /// Strikethrough: false
    /// Underline: false
    /// Paragraph spacing: 26
    /// Paragraph indent: default
    /// Line height: 42.97
    /// Letter spacing: -1.95
    public let typographyH2Bold = Typography(
        font: UIFont(name: "Inter-Bold", size: 39.0625),
        color: .label,
        strikethrough: false,
        underline: false,
        paragraphSpacing: 26,
        paragraphIndent: nil,
        lineHeight: 42.97,
        letterSpacing: -1.95
    )

    /// typography H2 Regular
    ///
    /// Font: Inter Regular
    /// Strikethrough: false
    /// Underline: false
    /// Paragraph spacing: 26
    /// Paragraph indent: default
    /// Line height: 42.97
    /// Letter spacing: -1.95
    public let typographyH2Regular = Typography(
        font: UIFont(name: "Inter-Regular", size: 39.0625),
        color: .label,
        strikethrough: false,
        underline: false,
        paragraphSpacing: 26,
        paragraphIndent: nil,
        lineHeight: 42.97,
        letterSpacing: -1.95
    )

    /// typography Body
    ///
    /// Font: Roboto Regular
    /// Strikethrough: false
    /// Underline: false
    /// Paragraph spacing: 26
    /// Paragraph indent: default
    /// Line height: 17.6
    /// Letter spacing: default
    public let typographyBody = Typography(
        font: UIFont(name: "Roboto-Regular", size: 16),
        color: .label,
        strikethrough: false,
        underline: false,
        paragraphSpacing: 26,
        paragraphIndent: nil,
        lineHeight: 17.6,
        letterSpacing: nil
    )
}

public struct Typography: Equatable {

    public enum ValidationError: Error, CustomStringConvertible {
        case fontNotFound(name: String, size: Double)

        public var description: String {
            switch self {
            case let .fontNotFound(name, size):
                return "Font '\(name) \(size)' couldn't be loaded"
            }
        }
    }

    public static func validate() throws {
        guard UIFont(name: "Inter-Bold", size: 48.828125) != nil else {
            throw ValidationError.fontNotFound(name: "Inter-Bold", size: 48.828125)
        }

        guard UIFont(name: "Inter-Regular", size: 48.828125) != nil else {
            throw ValidationError.fontNotFound(name: "Inter-Regular", size: 48.828125)
        }

        guard UIFont(name: "Inter-Bold", size: 39.0625) != nil else {
            throw ValidationError.fontNotFound(name: "Inter-Bold", size: 39.0625)
        }

        guard UIFont(name: "Inter-Regular", size: 39.0625) != nil else {
            throw ValidationError.fontNotFound(name: "Inter-Regular", size: 39.0625)
        }

        guard UIFont(name: "Roboto-Regular", size: 16) != nil else {
            throw ValidationError.fontNotFound(name: "Roboto-Regular", size: 16)
        }

        print("All text styles are valid")
    }

    public let font: UIFont?
    public let color: UIColor?
    public let backgroundColor: UIColor?
    public let strikethrough: Bool
    public let underline: Bool
    public let paragraphSpacing: CGFloat?
    public let paragraphIndent: CGFloat?
    public let lineHeight: CGFloat?
    public let letterSpacing: CGFloat?
    public let lineBreakMode: NSLineBreakMode?
    public let alignment: NSTextAlignment?

    public init(
        font: UIFont? = nil,
        color: UIColor? = nil,
        backgroundColor: UIColor? = nil,
        strikethrough: Bool = false,
        underline: Bool = false,
        paragraphSpacing: CGFloat? = nil,
        paragraphIndent: CGFloat? = nil,
        lineHeight: CGFloat? = nil,
        letterSpacing: CGFloat? = nil,
        lineBreakMode: NSLineBreakMode? = nil,
        alignment: NSTextAlignment? = nil
    ) {
        self.font = font
        self.color = color
        self.backgroundColor = backgroundColor
        self.strikethrough = strikethrough
        self.underline = underline
        self.paragraphSpacing = paragraphSpacing
        self.paragraphIndent = paragraphIndent
        self.lineHeight = lineHeight
        self.letterSpacing = letterSpacing
        self.lineBreakMode = lineBreakMode
        self.alignment = alignment
    }

    private func attributes(paragraphStyle: NSParagraphStyle?) -> [NSAttributedString.Key: Any] {
        var attributes: [NSAttributedString.Key: Any] = [:]

        if let paragraphStyle = paragraphStyle {
            attributes[.paragraphStyle] = paragraphStyle
        }

        if let font = font {
            attributes[.font] = font
        }

        if let color = color {
            attributes[.foregroundColor] = color
        }

        if let backgroundColor = backgroundColor {
            attributes[.backgroundColor] = backgroundColor
        }

        if strikethrough {
            attributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
        }

        if underline {
            attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }

        if let letterSpacing = letterSpacing {
            attributes[.kern] = letterSpacing
        }

        return attributes
    }

    public func paragraphStyle() -> NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()

        if let lineHeight = lineHeight {
            if let font = font {
                paragraphStyle.lineSpacing = (lineHeight - font.lineHeight) * 0.5
                paragraphStyle.minimumLineHeight = lineHeight - paragraphStyle.lineSpacing
            } else {
                paragraphStyle.lineSpacing = 0.0
                paragraphStyle.minimumLineHeight = lineHeight
            }

            paragraphStyle.maximumLineHeight = paragraphStyle.minimumLineHeight
        }

        if let paragraphSpacing = paragraphSpacing {
            paragraphStyle.paragraphSpacing = paragraphSpacing
        }

        if let paragraphIndent = paragraphIndent {
            paragraphStyle.firstLineHeadIndent = paragraphIndent
        }

        if let lineBreakMode = lineBreakMode {
            paragraphStyle.lineBreakMode = lineBreakMode
        }

        if let alignment = alignment {
            paragraphStyle.alignment = alignment
        }

        return paragraphStyle
    }

    public func attributes(includingParagraphStyle: Bool = true) -> [NSAttributedString.Key: Any] {
        if includingParagraphStyle {
            return attributes(paragraphStyle: paragraphStyle())
        } else {
            return attributes(paragraphStyle: nil)
        }
    }

    public func attributedString(
        _ string: String,
        includingParagraphStyle: Bool = true
    ) -> NSAttributedString {
        return NSAttributedString(string: string, style: self, includingParagraphStyle: includingParagraphStyle)
    }

    public func withFont(_ font: UIFont?) -> Typography {
        return Typography(
            font: font,
            color: color,
            backgroundColor: backgroundColor,
            strikethrough: strikethrough,
            underline: underline,
            paragraphSpacing: paragraphSpacing,
            paragraphIndent: paragraphIndent,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    public func withColor(_ color: UIColor?) -> Typography {
        return Typography(
            font: font,
            color: color,
            backgroundColor: backgroundColor,
            strikethrough: strikethrough,
            underline: underline,
            paragraphSpacing: paragraphSpacing,
            paragraphIndent: paragraphIndent,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    public func withBackgroundColor(_ backgroundColor: UIColor?) -> Typography {
        return Typography(
            font: font,
            color: color,
            backgroundColor: backgroundColor,
            strikethrough: strikethrough,
            underline: underline,
            paragraphSpacing: paragraphSpacing,
            paragraphIndent: paragraphIndent,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    public func withStrikethrough(_ strikethrough: Bool) -> Typography {
        return Typography(
            font: font,
            color: color,
            backgroundColor: backgroundColor,
            strikethrough: strikethrough,
            underline: underline,
            paragraphSpacing: paragraphSpacing,
            paragraphIndent: paragraphIndent,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    public func withUnderline(_ underline: Bool) -> Typography {
        return Typography(
            font: font,
            color: color,
            backgroundColor: backgroundColor,
            strikethrough: strikethrough,
            underline: underline,
            paragraphSpacing: paragraphSpacing,
            paragraphIndent: paragraphIndent,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    public func withParagraphSpacing(_ paragraphSpacing: CGFloat?) -> Typography {
        return Typography(
            font: font,
            color: color,
            backgroundColor: backgroundColor,
            strikethrough: strikethrough,
            underline: underline,
            paragraphSpacing: paragraphSpacing,
            paragraphIndent: paragraphIndent,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    public func withParagraphIndent(_ paragraphIndent: CGFloat?) -> Typography {
        return Typography(
            font: font,
            color: color,
            backgroundColor: backgroundColor,
            strikethrough: strikethrough,
            underline: underline,
            paragraphSpacing: paragraphSpacing,
            paragraphIndent: paragraphIndent,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    public func withLineHeight(_ lineHeight: CGFloat?) -> Typography {
        return Typography(
            font: font,
            color: color,
            backgroundColor: backgroundColor,
            strikethrough: strikethrough,
            underline: underline,
            paragraphSpacing: paragraphSpacing,
            paragraphIndent: paragraphIndent,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    public func withLetterSpacing(_ letterSpacing: CGFloat?) -> Typography {
        return Typography(
            font: font,
            color: color,
            backgroundColor: backgroundColor,
            strikethrough: strikethrough,
            underline: underline,
            paragraphSpacing: paragraphSpacing,
            paragraphIndent: paragraphIndent,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    public func withLineBreakMode(_ lineBreakMode: NSLineBreakMode?) -> Typography {
        return Typography(
            font: font,
            color: color,
            backgroundColor: backgroundColor,
            strikethrough: strikethrough,
            underline: underline,
            paragraphSpacing: paragraphSpacing,
            paragraphIndent: paragraphIndent,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    public func withAlignment(_ alignment: NSTextAlignment?) -> Typography {
        return Typography(
            font: font,
            color: color,
            backgroundColor: backgroundColor,
            strikethrough: strikethrough,
            underline: underline,
            paragraphSpacing: paragraphSpacing,
            paragraphIndent: paragraphIndent,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }
}

public extension NSAttributedString {

    convenience init(string: String, style: Typography, includingParagraphStyle: Bool = true) {
        self.init(string: string, attributes: style.attributes(includingParagraphStyle: includingParagraphStyle))
    }
}

public extension String {

    func styled(as typography: Typography) -> NSAttributedString {
        NSAttributedString(string: self, style: typography)
    }
}
