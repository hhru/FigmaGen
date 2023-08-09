// swiftlint:disable all
// Generated using FigmaGen - https://github.com/hhru/FigmaGen
#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

public enum Images {

    // MARK: - Nested Types

    public enum ValidationError: Error, CustomStringConvertible {
        case assetNotFound(name: String)
        case resourceNotFound(name: String)

        public var description: String {
            switch self {
            case let .assetNotFound(name):
                return "Image asset '\(name)' couldn't be loaded"

            case let .resourceNotFound(name):
                return "Image resource file '\(name)' couldn't be loaded"
            }
        }
    }

    public enum InterfaceEssentialInstagram {

        /// Style=Filled
        ///
        /// Asset: InterfaceEssentialInstagramStyleFilled
        public static var styleFilled: UIImage {
            return UIImage(named: "InterfaceEssentialInstagramStyleFilled")!
        }

        /// Style=Outlined
        ///
        /// Asset: InterfaceEssentialInstagramStyleOutlined
        public static var styleOutlined: UIImage {
            return UIImage(named: "InterfaceEssentialInstagramStyleOutlined")!
        }
    }

    public enum InterfaceEssentialDribbble {

        /// Style=Filled
        ///
        /// Asset: InterfaceEssentialDribbbleStyleFilled
        public static var styleFilled: UIImage {
            return UIImage(named: "InterfaceEssentialDribbbleStyleFilled")!
        }

        /// Style=Outlined
        ///
        /// Asset: InterfaceEssentialDribbbleStyleOutlined
        public static var styleOutlined: UIImage {
            return UIImage(named: "InterfaceEssentialDribbbleStyleOutlined")!
        }
    }

    public enum InterfaceEssentialBehance {

        /// Style=Filled
        ///
        /// Asset: InterfaceEssentialBehanceStyleFilled
        public static var styleFilled: UIImage {
            return UIImage(named: "InterfaceEssentialBehanceStyleFilled")!
        }

        /// Style=Outlined
        ///
        /// Asset: InterfaceEssentialBehanceStyleOutlined
        public static var styleOutlined: UIImage {
            return UIImage(named: "InterfaceEssentialBehanceStyleOutlined")!
        }
    }

    public enum InterfaceEssentialLinkedin {

        /// Style=Filled
        ///
        /// Asset: InterfaceEssentialLinkedinStyleFilled
        public static var styleFilled: UIImage {
            return UIImage(named: "InterfaceEssentialLinkedinStyleFilled")!
        }

        /// Style=Outlined
        ///
        /// Asset: InterfaceEssentialLinkedinStyleOutlined
        public static var styleOutlined: UIImage {
            return UIImage(named: "InterfaceEssentialLinkedinStyleOutlined")!
        }
    }

    public enum InterfaceEssentialTwitter {

        /// Style=Filled
        ///
        /// Asset: InterfaceEssentialTwitterStyleFilled
        public static var styleFilled: UIImage {
            return UIImage(named: "InterfaceEssentialTwitterStyleFilled")!
        }

        /// Style=Outlined
        ///
        /// Asset: InterfaceEssentialTwitterStyleOutlined
        public static var styleOutlined: UIImage {
            return UIImage(named: "InterfaceEssentialTwitterStyleOutlined")!
        }
    }

    public enum InterfaceEssentialFacebook {

        /// Style=Filled
        ///
        /// Asset: InterfaceEssentialFacebookStyleFilled
        public static var styleFilled: UIImage {
            return UIImage(named: "InterfaceEssentialFacebookStyleFilled")!
        }

        /// Outlined
        ///
        /// Asset: InterfaceEssentialFacebookOutlined
        public static var outlined: UIImage {
            return UIImage(named: "InterfaceEssentialFacebookOutlined")!
        }
    }

    public enum InterfaceEssentialGoogle {

        /// Style=Filled
        ///
        /// Asset: InterfaceEssentialGoogleStyleFilled
        public static var styleFilled: UIImage {
            return UIImage(named: "InterfaceEssentialGoogleStyleFilled")!
        }

        /// Style=Outlined
        ///
        /// Asset: InterfaceEssentialGoogleStyleOutlined
        public static var styleOutlined: UIImage {
            return UIImage(named: "InterfaceEssentialGoogleStyleOutlined")!
        }
    }

    public enum InterfaceEssentialFigma {

        /// Style=Filled
        ///
        /// Asset: InterfaceEssentialFigmaStyleFilled
        public static var styleFilled: UIImage {
            return UIImage(named: "InterfaceEssentialFigmaStyleFilled")!
        }

        /// Style=Outlined
        ///
        /// Asset: InterfaceEssentialFigmaStyleOutlined
        public static var styleOutlined: UIImage {
            return UIImage(named: "InterfaceEssentialFigmaStyleOutlined")!
        }
    }

    // MARK: - Type Properties


    /// WeChat
    ///
    /// Asset: WeChat
    public static var weChat: UIImage {
        return UIImage(named: "WeChat")!
    }

    /// Snapchat
    ///
    /// Asset: Snapchat
    public static var snapchat: UIImage {
        return UIImage(named: "Snapchat")!
    }

    /// Viber
    ///
    /// Asset: Viber
    public static var viber: UIImage {
        return UIImage(named: "Viber")!
    }

    /// WhatsApp
    ///
    /// Asset: WhatsApp
    public static var whatsApp: UIImage {
        return UIImage(named: "WhatsApp")!
    }

    /// Telegram
    ///
    /// Asset: Telegram
    public static var telegram: UIImage {
        return UIImage(named: "Telegram")!
    }

    /// Cloud
    ///
    /// Asset: Cloud
    public static var cloud: UIImage {
        return UIImage(named: "Cloud")!
    }

    /// Phone
    ///
    /// Asset: Phone
    public static var phone: UIImage {
        return UIImage(named: "Phone")!
    }

    /// Share
    ///
    /// Asset: Share
    public static var share: UIImage {
        return UIImage(named: "Share")!
    }

    /// Star
    ///
    /// Asset: Star
    public static var star: UIImage {
        return UIImage(named: "Star")!
    }

    /// Geo
    ///
    /// Asset: Geo
    public static var geo: UIImage {
        return UIImage(named: "Geo")!
    }

    // MARK: - Type Methods

    public static func validate() throws {
        guard UIImage(named: "WeChat") != nil else {
            throw ValidationError.assetNotFound(name: "WeChat")
        }

        guard UIImage(named: "Snapchat") != nil else {
            throw ValidationError.assetNotFound(name: "Snapchat")
        }

        guard UIImage(named: "Viber") != nil else {
            throw ValidationError.assetNotFound(name: "Viber")
        }

        guard UIImage(named: "WhatsApp") != nil else {
            throw ValidationError.assetNotFound(name: "WhatsApp")
        }

        guard UIImage(named: "Telegram") != nil else {
            throw ValidationError.assetNotFound(name: "Telegram")
        }

        guard UIImage(named: "Cloud") != nil else {
            throw ValidationError.assetNotFound(name: "Cloud")
        }

        guard UIImage(named: "Phone") != nil else {
            throw ValidationError.assetNotFound(name: "Phone")
        }

        guard UIImage(named: "Share") != nil else {
            throw ValidationError.assetNotFound(name: "Share")
        }

        guard UIImage(named: "Star") != nil else {
            throw ValidationError.assetNotFound(name: "Star")
        }

        guard UIImage(named: "Geo") != nil else {
            throw ValidationError.assetNotFound(name: "Geo")
        }

        guard UIImage(named: "InterfaceEssentialInstagramStyleFilled") != nil else {
            throw ValidationError.assetNotFound(name: "InterfaceEssentialInstagramStyleFilled")
        }

        guard UIImage(named: "InterfaceEssentialInstagramStyleOutlined") != nil else {
            throw ValidationError.assetNotFound(name: "InterfaceEssentialInstagramStyleOutlined")
        }

        guard UIImage(named: "InterfaceEssentialDribbbleStyleFilled") != nil else {
            throw ValidationError.assetNotFound(name: "InterfaceEssentialDribbbleStyleFilled")
        }

        guard UIImage(named: "InterfaceEssentialDribbbleStyleOutlined") != nil else {
            throw ValidationError.assetNotFound(name: "InterfaceEssentialDribbbleStyleOutlined")
        }

        guard UIImage(named: "InterfaceEssentialBehanceStyleFilled") != nil else {
            throw ValidationError.assetNotFound(name: "InterfaceEssentialBehanceStyleFilled")
        }

        guard UIImage(named: "InterfaceEssentialBehanceStyleOutlined") != nil else {
            throw ValidationError.assetNotFound(name: "InterfaceEssentialBehanceStyleOutlined")
        }

        guard UIImage(named: "InterfaceEssentialLinkedinStyleFilled") != nil else {
            throw ValidationError.assetNotFound(name: "InterfaceEssentialLinkedinStyleFilled")
        }

        guard UIImage(named: "InterfaceEssentialLinkedinStyleOutlined") != nil else {
            throw ValidationError.assetNotFound(name: "InterfaceEssentialLinkedinStyleOutlined")
        }

        guard UIImage(named: "InterfaceEssentialTwitterStyleFilled") != nil else {
            throw ValidationError.assetNotFound(name: "InterfaceEssentialTwitterStyleFilled")
        }

        guard UIImage(named: "InterfaceEssentialTwitterStyleOutlined") != nil else {
            throw ValidationError.assetNotFound(name: "InterfaceEssentialTwitterStyleOutlined")
        }

        guard UIImage(named: "InterfaceEssentialFacebookStyleFilled") != nil else {
            throw ValidationError.assetNotFound(name: "InterfaceEssentialFacebookStyleFilled")
        }

        guard UIImage(named: "InterfaceEssentialFacebookOutlined") != nil else {
            throw ValidationError.assetNotFound(name: "InterfaceEssentialFacebookOutlined")
        }

        guard UIImage(named: "InterfaceEssentialGoogleStyleFilled") != nil else {
            throw ValidationError.assetNotFound(name: "InterfaceEssentialGoogleStyleFilled")
        }

        guard UIImage(named: "InterfaceEssentialGoogleStyleOutlined") != nil else {
            throw ValidationError.assetNotFound(name: "InterfaceEssentialGoogleStyleOutlined")
        }

        guard UIImage(named: "InterfaceEssentialFigmaStyleFilled") != nil else {
            throw ValidationError.assetNotFound(name: "InterfaceEssentialFigmaStyleFilled")
        }

        guard UIImage(named: "InterfaceEssentialFigmaStyleOutlined") != nil else {
            throw ValidationError.assetNotFound(name: "InterfaceEssentialFigmaStyleOutlined")
        }

        print("All images are valid")
    }
}
