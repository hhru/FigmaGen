import Foundation

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

    mutating func readCommand() -> Character? {
        skipSeparators()

        guard index < characters.count, characters[index].isLetter else {
            return nil
        }

        defer { index += 1 }

        return characters[index]
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

    // Arc flags may be written without separators, so they are always a single digit.
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
