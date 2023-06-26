import Foundation
import DictionaryCoder

final class DefaultTemplateContextCoder: TemplateContextCoder {

    // MARK: - Instance Properties

    let dictionaryDecoder = DictionaryDecoder()
    let dictionaryEncoder = DictionaryEncoder()

    // MARK: - Instance Methods

    func decode<T: Decodable>(_ type: T.Type, from dictionary: [String: Any]) throws -> T {
        try dictionaryDecoder.decode(type, from: dictionary)
    }

    func encode<T: Encodable>(_ value: T) throws -> [String: Any] {
        try dictionaryEncoder.encode(value)
    }
}
