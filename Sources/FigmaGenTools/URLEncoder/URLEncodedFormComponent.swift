import Foundation

internal enum URLEncodedFormComponent {

    // MARK: - Enumeration Cases

    case string(String)
    case array([Self])
    case dictionary([String: Self])

    // MARK: - Instance Properties

    internal var array: [Self]? {
        switch self {
        case let .array(array):
            return array

        default:
            return nil
        }
    }

    internal var dictionary: [String: Self]? {
        switch self {
        case let .dictionary(object):
            return object

        default:
            return nil
        }
    }
}
