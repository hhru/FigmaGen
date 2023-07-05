import Foundation

extension String {

    // MARK: - Type Properties

    public static let empty = ""

    // MARK: - Instance Properties

    public var firstUppercased: String {
        prefix(1).uppercased().appending(dropFirst())
    }

    public var firstLowercased: String {
        prefix(1).lowercased().appending(dropFirst())
    }

    public var firstCapitalized: String {
        prefix(1).capitalized.appending(dropFirst())
    }

    public var camelized: String {
        components(separatedBy: CharacterSet.alphanumerics.inverted)
            .map { $0.firstUppercased }
            .joined()
    }

    // MARK: - Instance Methods

    public func slice(
        from startCharactet: Character,
        to endCharacter: Character,
        includingBounds: Bool
    ) -> Substring? {
        if includingBounds {
            guard let startIndex = firstIndex(of: startCharactet) else {
                return nil
            }

            guard let endIndex = firstIndex(of: endCharacter) else {
                return nil
            }

            let substringRange = startIndex...endIndex

            return self[substringRange]
        }

        guard let rangeFrom = range(of: String(startCharactet))?.upperBound else {
            return nil
        }

        guard let rangeTo = self[rangeFrom...].range(of: String(endCharacter))?.lowerBound else {
            return nil
        }

        return self[rangeFrom..<rangeTo]
    }
}
