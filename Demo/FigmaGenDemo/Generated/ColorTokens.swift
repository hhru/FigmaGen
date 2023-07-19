// swiftlint:disable all
// Generated using FigmaGen - https://github.com/hhru/FigmaGen

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

public struct ColorTokens {
    public struct Accent {
        /// accent.bg
        ///
        /// Day: #c3dafe
        /// Night: #434190
        public let bg: UIColor
        /// accent.default
        ///
        /// Day: #7f9cf5
        /// Night: #5a67d8
        public let `default`: UIColor
        /// accent.onAccent
        ///
        /// Day: #ffffff
        /// Night: #ffffff
        public let onAccent: UIColor
    }

    public let accent: Accent
    public struct Bg {
        /// bg.default
        ///
        /// Day: #ffffff
        /// Night: #1a202c
        public let `default`: UIColor
        /// bg.muted
        ///
        /// Day: #f7fafc
        /// Night: #4a5568
        public let muted: UIColor
        /// bg.subtle
        ///
        /// Day: #edf2f7
        /// Night: #718096
        public let subtle: UIColor
    }

    public let bg: Bg
    public struct Fg {
        /// fg.default
        ///
        /// Day: #000000
        /// Night: #ffffff
        public let `default`: UIColor
        /// fg.muted
        ///
        /// Day: #4a5568
        /// Night: #e2e8f0
        public let muted: UIColor
        /// fg.subtle
        ///
        /// Day: #a0aec0
        /// Night: #a0aec0
        public let subtle: UIColor
    }

    public let fg: Fg
    public struct Shadows {
        /// shadows.default
        ///
        /// Day: #1a202c
        /// Night: #00000000
        public let `default`: UIColor
    }

    public let shadows: Shadows
}
