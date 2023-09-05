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

    public var snakeCased: String {
        components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .map { $0.lowercased() }
            .joined(separator: "_")
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

    public func replacingOccurrences(
        matchingPattern pattern: String,
        replacementProvider: (String) throws -> String
    ) throws -> String {
        let expression = try NSRegularExpression(pattern: pattern, options: [])
        let matches = expression.matches(in: self, options: [], range: NSRange(startIndex..<endIndex, in: self))

        return try matches
            .reversed()
            .reduce(into: self) { current, result in
                guard let range = Range(result.range, in: current) else {
                    return
                }

                let token = String(current[range])
                let replacement = try replacementProvider(token)

                current.replaceSubrange(range, with: replacement)
            }
    }
}
