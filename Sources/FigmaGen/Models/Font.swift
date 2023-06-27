import Foundation

struct Font: Codable, Hashable {

    // MARK: - Instance Properties

    let family: String
    let name: String
    let weight: Double
    let size: Double
}

extension Font {

    // MARK: - Instance Properties

    var isSystemFont: Bool {
        name.contains(String.textSystemFontName) || name.contains(String.displaySystemFontName)
    }
}

extension String {

    // MARK: - Type Properties

    fileprivate static let textSystemFontName = "SFProText"
    fileprivate static let displaySystemFontName = "SFProDisplay"
}
