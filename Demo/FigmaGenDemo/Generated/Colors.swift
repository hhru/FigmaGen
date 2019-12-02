// swiftlint:disable all
import UIKit.UIColor

public enum Colors {

    /// Gray
    ///
    /// Hex: #A9A9A9FF; rgba: 169 169 169, 100%.
    public static let gray = UIColor(rgbaHex: 0xA9A9A9FF)

    /// Black
    ///
    /// Hex: #313033FF; rgba: 49 48 51, 100%.
    public static let black = UIColor(rgbaHex: 0x313033FF)

    /// Slate Gray
    ///
    /// Hex: #708090FF; rgba: 112 128 144, 100%.
    public static let slateGray = UIColor(rgbaHex: 0x708090FF)

    /// Dark Gray
    ///
    /// Hex: #696969FF; rgba: 105 105 105, 100%.
    public static let darkGray = UIColor(rgbaHex: 0x696969FF)

    /// Light Gray
    ///
    /// Hex: #D3D3D3FF; rgba: 211 211 211, 100%.
    public static let lightGray = UIColor(rgbaHex: 0xD3D3D3FF)

    /// White Smoke
    ///
    /// Hex: #F5F6F6FF; rgba: 245 246 246, 100%.
    public static let whiteSmoke = UIColor(rgbaHex: 0xF5F6F6FF)

    /// White
    ///
    /// Hex: #FDFDFFFF; rgba: 253 253 255, 100%.
    public static let white = UIColor(rgbaHex: 0xFDFDFFFF)

    /// Jungle
    ///
    /// Hex: #29AB87FF; rgba: 41 171 135, 100%.
    public static let jungle = UIColor(rgbaHex: 0x29AB87FF)

    /// Fuscia
    ///
    /// Hex: #E958A7FF; rgba: 233 88 167, 100%.
    public static let fuscia = UIColor(rgbaHex: 0xE958A7FF)

    /// Bumblebee
    ///
    /// Hex: #FCE205FF; rgba: 252 226 5, 100%.
    public static let bumblebee = UIColor(rgbaHex: 0xFCE205FF)

    /// Electric
    ///
    /// Hex: #8F00FFFF; rgba: 143 0 255, 100%.
    public static let electric = UIColor(rgbaHex: 0x8F00FFFF)

    /// Carolina
    ///
    /// Hex: #57A0D2FF; rgba: 87 160 210, 100%.
    public static let carolina = UIColor(rgbaHex: 0x57A0D2FF)

    /// Imperial
    ///
    /// Hex: #ED2939FF; rgba: 237 41 57, 100%.
    public static let imperial = UIColor(rgbaHex: 0xED2939FF)
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
