import Foundation

/// Посимвольный сканер, общий для данных пути (`d`) и для списка преобразований (`transform`).
struct SVGReader {

    // MARK: - Type Properties

    private static let separators: Set<Character> = [" ", ",", "\n", "\r", "\t"]

    // MARK: - Instance Properties

    private let characters: [Character]

    private var index = 0

    // MARK: - Initializers

    init(_ text: String) {
        characters = Array(text)
    }

    // MARK: - Instance Methods

    private mutating func skipSeparators() {
        while index < characters.count, Self.separators.contains(characters[index]) {
            index += 1
        }
    }

    private func isDigit(at index: Int) -> Bool {
        index < characters.count && characters[index].isASCII && characters[index].isNumber
    }

    /// `true`, если, кроме разделителей, в строке ничего не осталось.
    /// Нужна, чтобы не проглатывать молча хвост, который не удалось разобрать.
    mutating func isAtEnd() -> Bool {
        skipSeparators()

        return index >= characters.count
    }

    mutating func readCommand() -> Character? {
        skipSeparators()

        guard index < characters.count, characters[index].isLetter else {
            return nil
        }

        defer { index += 1 }

        return characters[index]
    }

    /// Имя функции преобразования: `translate`, `matrix` и т.д.
    mutating func readIdentifier() -> String? {
        skipSeparators()

        let start = index

        while index < characters.count, characters[index].isLetter {
            index += 1
        }

        guard index > start else {
            return nil
        }

        return String(characters[start..<index])
    }

    /// Считывает ожидаемый символ и возвращает `true`, если он там действительно был.
    mutating func readCharacter(_ character: Character) -> Bool {
        skipSeparators()

        guard index < characters.count, characters[index] == character else {
            return false
        }

        index += 1

        return true
    }

    mutating func hasNumber() -> Bool {
        skipSeparators()

        guard index < characters.count else {
            return false
        }

        let character = characters[index]

        return isDigit(at: index) || character == "." || character == "-" || character == "+"
    }

    mutating func readNumber() -> Double? {
        skipSeparators()

        let start = index

        if index < characters.count, characters[index] == "-" || characters[index] == "+" {
            index += 1
        }

        var hasDigits = false

        while isDigit(at: index) {
            index += 1
            hasDigits = true
        }

        if index < characters.count, characters[index] == "." {
            index += 1

            while isDigit(at: index) {
                index += 1
                hasDigits = true
            }
        }

        guard hasDigits else {
            index = start

            return nil
        }

        if index < characters.count, characters[index] == "e" || characters[index] == "E" {
            let exponentStart = index

            index += 1

            if index < characters.count, characters[index] == "-" || characters[index] == "+" {
                index += 1
            }

            var hasExponentDigits = false

            while isDigit(at: index) {
                index += 1
                hasExponentDigits = true
            }

            if !hasExponentDigits {
                index = exponentStart
            }
        }

        return Double(String(characters[start..<index]))
    }

    /// Флаги дуги можно записывать без разделителей, поэтому это всегда ровно одна цифра.
    mutating func readFlag() -> Double? {
        skipSeparators()

        guard index < characters.count else {
            return nil
        }

        switch characters[index] {
        case "0":
            index += 1

            return 0.0

        case "1":
            index += 1

            return 1.0

        default:
            return nil
        }
    }
}
