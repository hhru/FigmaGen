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

    public func split(usingRegex pattern: String) throws -> [String] {
        let regex = try NSRegularExpression(pattern: pattern)
        let matches = regex.matches(in: self, range: NSRange(0..<utf16.count))

        let ranges = [startIndex..<startIndex]
            + matches.compactMap { Range($0.range, in: self) }
            + [endIndex..<endIndex]

        return (0...matches.count).map { String(self[ranges[$0].upperBound..<ranges[$0 + 1].lowerBound]) }
    }
}
