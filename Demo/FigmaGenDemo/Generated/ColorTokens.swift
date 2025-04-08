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
        /// hh-day: #c3dafe
        /// hh-night: #434190
        public let bg: UIColor
        /// accent.default
        ///
        /// hh-day: #7f9cf5
        /// hh-night: #5a67d8
        public let `default`: UIColor
        /// accent.onAccent
        ///
        /// hh-day: #ffffff
        /// hh-night: #ffffff
        public let onAccent: UIColor
    }

    public let accent: Accent
    public struct Bg {
        /// bg.default
        ///
        /// hh-day: #ffffff
        /// hh-night: #1a202c
        public let `default`: UIColor
        /// bg.muted
        ///
        /// hh-day: #f7fafc
        /// hh-night: #4a5568
        public let muted: UIColor
        /// bg.subtle
        ///
        /// hh-day: #edf2f7
        /// hh-night: #718096
        public let subtle: UIColor
    }

    public let bg: Bg
    public struct Fg {
        /// fg.default
        ///
        /// hh-day: #000000
        /// hh-night: #ffffff
        public let `default`: UIColor
        /// fg.muted
        ///
        /// hh-day: #4a5568
        /// hh-night: #e2e8f0
        public let muted: UIColor
        /// fg.subtle
        ///
        /// hh-day: #a0aec0
        /// hh-night: #a0aec0
        public let subtle: UIColor
    }

    public let fg: Fg
    public struct Shadows {
        /// shadows.default
        ///
        /// hh-day: #1a202c
        /// hh-night: #00000000
        public let `default`: UIColor
    }

    public let shadows: Shadows
}
