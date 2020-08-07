// swiftlint:disable all
import UIKit

public protocol Spacing {
    init(_ value: Double)
}

extension Int: Spacing { }
extension UInt: Spacing { }
extension Float: Spacing { }
extension Double: Spacing { }
extension CGFloat: Spacing { }

extension Spacing {

    /// L
    ///
    /// Value: 24.0.
    public static var l: Self { Self(24.0) }

    /// M
    ///
    /// Value: 16.0.
    public static var m: Self { Self(16.0) }

    /// MPlus
    ///
    /// Value: 20.0.
    public static var mplus: Self { Self(20.0) }

    /// S
    ///
    /// Value: 12.0.
    public static var s: Self { Self(12.0) }

    /// XL
    ///
    /// Value: 32.0.
    public static var xl: Self { Self(32.0) }

    /// XS
    ///
    /// Value: 8.0.
    public static var xs: Self { Self(8.0) }

    /// XXS
    ///
    /// Value: 4.0.
    public static var xxs: Self { Self(4.0) }

    /// XXXS
    ///
    /// Value: 1.0.
    public static var xxxs: Self { Self(1.0) }
}
// swiftlint:enable all
