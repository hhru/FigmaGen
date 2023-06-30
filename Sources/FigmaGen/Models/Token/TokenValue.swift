import Foundation

struct TokenValue: Hashable {

    // MARK: - Instance Properties

    let type: TokenValueType
    let name: String
}

// MARK: - Decodable

extension TokenValue: Decodable {

    // MARK: - Nested Types

    private enum RawType: String, Decodable {
        case a11yScales
        case animation
        case borderRadius
        case boxShadow
        case color
        case core
        case dimension
        case fontFamilies
        case fontSizes
        case fontWeights
        case letterSpacing
        case lineHeights
        case opacity
        case paragraphSpacing
        case scaling
        case sizing
        case spacing
        case textCase
        case textDecoration
        case typography
    }

    fileprivate enum CodingKeys: String, CodingKey {
        case type
        case name
        case value
    }

    // MARK: - Initializers

    init(from decoder: Decoder) throws {
        // swiftlint:disable:previous function_body_length
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try container.decode(forKey: .name)

        let rawType = try container.decode(RawType.self, forKey: .type)

        switch rawType {
        case .a11yScales:
            self.type = .a11yScales(value: try container.decode(forKey: .value))

        case .animation:
            self.type = .animation(value: try container.decode(forKey: .value))

        case .borderRadius:
            self.type = .borderRadius(value: try container.decode(forKey: .value))

        case .boxShadow:
            self.type = .boxShadow(value: try container.decode(forKey: .value))

        case .color:
            self.type = .color(value: try container.decode(forKey: .value))

        case .core:
            self.type = .core(value: try container.decode(forKey: .value))

        case .dimension:
            self.type = .dimension(value: try container.decode(forKey: .value))

        case .fontFamilies:
            self.type = .fontFamilies(value: try container.decode(forKey: .value))

        case .fontSizes:
            self.type = .fontSizes(value: try container.decode(forKey: .value))

        case .fontWeights:
            self.type = .fontWeights(value: try container.decode(forKey: .value))

        case .letterSpacing:
            self.type = .letterSpacing(value: try container.decode(forKey: .value))

        case .lineHeights:
            self.type = .lineHeights(value: try container.decode(forKey: .value))

        case .opacity:
            self.type = .opacity(value: try container.decode(forKey: .value))

        case .paragraphSpacing:
            self.type = .paragraphSpacing(value: try container.decode(forKey: .value))

        case .scaling:
            self.type = .scaling(value: try container.decode(forKey: .value))

        case .sizing:
            self.type = .sizing(value: try container.decode(forKey: .value))

        case .spacing:
            self.type = .spacing(value: try container.decode(forKey: .value))

        case .textCase:
            self.type = .textCase(value: try container.decode(forKey: .value))

        case .textDecoration:
            self.type = .textDecoration(value: try container.decode(forKey: .value))

        case .typography:
            self.type = .typography(value: try container.decode(forKey: .value))
        }
    }
}

// MARK: - Encodable

extension TokenValue: Encodable {

    // MARK: - Instance Methods

    func encode(to encoder: Encoder) throws {
        // swiftlint:disable:previous function_body_length
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(name, forKey: .name)

        switch type {
        case let .a11yScales(value):
            try container.encode(value, forKey: .value)

        case let .animation(value):
            try container.encode(value, forKey: .value)

        case let .borderRadius(value):
            try container.encode(value, forKey: .value)

        case let .boxShadow(value):
            try container.encode(value, forKey: .value)

        case let .color(value):
            try container.encode(value, forKey: .value)

        case let .core(value):
            try container.encode(value, forKey: .value)

        case let .dimension(value):
            try container.encode(value, forKey: .value)

        case let .fontFamilies(value):
            try container.encode(value, forKey: .value)

        case let .fontSizes(value):
            try container.encode(value, forKey: .value)

        case let .fontWeights(value):
            try container.encode(value, forKey: .value)

        case let .letterSpacing(value):
            try container.encode(value, forKey: .value)

        case let .lineHeights(value):
            try container.encode(value, forKey: .value)

        case let .opacity(value):
            try container.encode(value, forKey: .value)

        case let .paragraphSpacing(value):
            try container.encode(value, forKey: .value)

        case let .scaling(value):
            try container.encode(value, forKey: .value)

        case let .sizing(value):
            try container.encode(value, forKey: .value)

        case let .spacing(value):
            try container.encode(value, forKey: .value)

        case let .textCase(value):
            try container.encode(value, forKey: .value)

        case let .textDecoration(value):
            try container.encode(value, forKey: .value)

        case let .typography(value):
            try container.encode(value, forKey: .value)
        }
    }
}
