import Foundation

enum SVGNumber {

    /// Форматирует число для атрибутов SVG: до шести знаков после запятой, без хвостовых нулей
    /// и без отрицательного нуля.
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
