import Foundation

enum SVGNumber {

    // MARK: - Type Methods

    /// Упорядочивает форматы так же, как и в конвейере обработки ссылок: шесть знаков после запятой без нулей в конце.
    static func string(from value: Double) -> String {
        var text = String(format: "%.6f", value)

        if text.contains(".") {
            while text.hasSuffix("0") {
                text.removeLast()
            }

            if text.hasSuffix(".") {
                text.removeLast()
            }
        }

        return text == "-0" ? "0" : text
    }
}
