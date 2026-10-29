import Foundation

/// Произвольное JSON-значение из файла токенов в формате W3C (DTCG).
///
/// Сохраняет различие между строками и числами, которое теряется при декодировании в `[String: String]`.
indirect enum W3CTokenJSON: Decodable, Hashable {

    // MARK: - Enumeration Cases

    case string(String)
    case number(Double)
    case bool(Bool)
    case array([W3CTokenJSON])
    case object([String: W3CTokenJSON])
    case none

    // MARK: - Instance Properties

    /// Строковое представление скалярного значения.
    /// Числа форматируются как `Double`: `2` → `"2.0"`, `0.96` → `"0.96"`.
    var stringValue: String? {
        switch self {
        case let .string(value):
            return value

        case let .number(value):
            return String(value)

        case let .bool(value):
            return value ? "true" : "false"

        case .array, .object, .none:
            return nil
        }
    }

    var objectValue: [String: Self]? {
        guard case let .object(value) = self else {
            return nil
        }

        return value
    }

    var arrayValue: [Self]? {
        guard case let .array(value) = self else {
            return nil
        }

        return value
    }

    // MARK: - Initializers

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self = .none
        } else if let value = try? container.decode(Double.self) {
            self = .number(value)
        } else if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
        } else if let value = try? container.decode([Self].self) {
            self = .array(value)
        } else {
            self = .object(try container.decode([String: Self].self))
        }
    }
}
