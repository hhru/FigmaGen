// swiftlint:disable all
// Generated using FigmaGen - https://github.com/hhru/FigmaGen

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

public struct BorderToken: Hashable {
    public let width: CGFloat
    public let style: String

    public init(width: CGFloat, style: String) {
        self.width = width
        self.style = style
    }
}

internal struct BorderTokens {
    // MARK: - Instance Properties

    /// semantic.border.applied
    ///
    /// Width: 2
    /// Style: solid
    internal var semanticBorderApplied: BorderToken {
        BorderToken(
            width: 2,
            style: "solid"
        )
    }

    /// semantic.border.checkable
    ///
    /// Width: 1.5
    /// Style: solid
    internal var semanticBorderCheckable: BorderToken {
        BorderToken(
            width: 1.5,
            style: "solid"
        )
    }

    /// semantic.border.dashed-default
    ///
    /// Width: 2
    /// Style: dashed
    internal var semanticBorderDashedDefault: BorderToken {
        BorderToken(
            width: 2,
            style: "dashed"
        )
    }

    /// semantic.border.dashed-focused
    ///
    /// Width: 2
    /// Style: dashed
    internal var semanticBorderDashedFocused: BorderToken {
        BorderToken(
            width: 2,
            style: "dashed"
        )
    }

    /// semantic.border.default
    ///
    /// Width: 1
    /// Style: solid
    internal var semanticBorderDefault: BorderToken {
        BorderToken(
            width: 1,
            style: "solid"
        )
    }

    /// semantic.border.disabled
    ///
    /// Width: 1
    /// Style: solid
    internal var semanticBorderDisabled: BorderToken {
        BorderToken(
            width: 1,
            style: "solid"
        )
    }

    /// semantic.border.focused
    ///
    /// Width: 2
    /// Style: solid
    internal var semanticBorderFocused: BorderToken {
        BorderToken(
            width: 2,
            style: "solid"
        )
    }

    /// semantic.border.hovered
    ///
    /// Width: 1
    /// Style: solid
    internal var semanticBorderHovered: BorderToken {
        BorderToken(
            width: 1,
            style: "solid"
        )
    }

    /// semantic.border.invalid
    ///
    /// Width: 1
    /// Style: solid
    internal var semanticBorderInvalid: BorderToken {
        BorderToken(
            width: 1,
            style: "solid"
        )
    }

    /// semantic.border.selected
    ///
    /// Width: 2
    /// Style: solid
    internal var semanticBorderSelected: BorderToken {
        BorderToken(
            width: 2,
            style: "solid"
        )
    }

    /// semantic.border.tab-focused
    ///
    /// Width: 4
    /// Style: solid
    internal var semanticBorderTabFocused: BorderToken {
        BorderToken(
            width: 4,
            style: "solid"
        )
    }
}
