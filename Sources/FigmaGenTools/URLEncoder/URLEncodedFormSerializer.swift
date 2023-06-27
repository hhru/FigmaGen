import Foundation

internal final class URLEncodedFormSerializer {

    // MARK: - Instance Properties

    internal let arrayEncodingStrategy: URLArrayEncodingStrategy
    internal let spaceEncodingStrategy: URLSpaceEncodingStrategy

    // MARK: - Initializers

    internal init(
        arrayEncodingStrategy: URLArrayEncodingStrategy,
        spaceEncodingStrategy: URLSpaceEncodingStrategy
    ) {
        self.arrayEncodingStrategy = arrayEncodingStrategy
        self.spaceEncodingStrategy = spaceEncodingStrategy
    }

    // MARK: - Instance Methods

    private func escapeString(_ string: String) -> String {
        var allowedCharacters = CharacterSet.urlQueryAllowed

        allowedCharacters.remove(charactersIn: .urlDelimiters)
        allowedCharacters.insert(charactersIn: .urlUnescapedSpace)

        let escapedString = string.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? string

        switch spaceEncodingStrategy {
        case .percentEscaped:
            return escapedString.replacingOccurrences(
                of: String.urlUnescapedSpace,
                with: String.urlPercentEscapedSpace
            )

        case .plusReplaced:
            return escapedString.replacingOccurrences(
                of: String.urlUnescapedSpace,
                with: String.urlPlusReplacedSpace
            )
        }
    }

    private func serializeComponent(_ component: URLEncodedFormComponent, key: String) -> String {
        switch component {
        case let .string(value):
            return .urlStringComponent(key: escapeString(key), value: escapeString(value))

        case let .array(value):
            return value
                .map { element in
                    switch arrayEncodingStrategy {
                    case .brackets:
                        return serializeComponent(element, key: .urlBracketsArrayComponentKey(key))

                    case .noBrackets:
                        return serializeComponent(element, key: .urlNoBracketsArrayComponentKey(key))
                    }
                }
                .joined(separator: .urlComponentSeparator)

        case let .dictionary(value):
            return value
                .map { serializeComponent($0.value, key: .urlDictionaryComponentKey(key, elementKey: $0.key)) }
                .joined(separator: .urlComponentSeparator)
        }
    }

    // MARK: -

    internal func serialize(_ form: URLEncodedForm) -> String {
        form
            .map { serializeComponent($0.value, key: $0.key) }
            .joined(separator: .urlComponentSeparator)
    }
}

extension String {

    // MARK: - Type Properties

    fileprivate static let urlDelimiters = ":#[]@!$&'()*+,;="
    fileprivate static let urlUnescapedSpace = " "

    fileprivate static let urlPercentEscapedSpace = "%20"
    fileprivate static let urlPlusReplacedSpace = "+"

    fileprivate static let urlComponentSeparator = "&"

    // MARK: - Type Methods

    fileprivate static func urlStringComponent(key: String, value: String) -> String {
        "\(key)=\(value)"
    }

    fileprivate static func urlBracketsArrayComponentKey(_ key: String) -> String {
        "\(key)[]"
    }

    fileprivate static func urlNoBracketsArrayComponentKey(_ key: String) -> String {
        key
    }

    fileprivate static func urlDictionaryComponentKey(_ key: String, elementKey: String) -> String {
        "\(key)[\(elementKey)]"
    }
}
