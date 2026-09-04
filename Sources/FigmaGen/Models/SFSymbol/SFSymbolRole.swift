import Foundation

enum SFSymbolRole: String {

    case primary
    case secondary
    case tertiary

    // MARK: - Initializers

    init(of path: SVGPath, layerNames: [String]) {
        if let ownRole = path.id.flatMap({ Self(rawValue: $0.lowercased()) }) {
            self = ownRole
        } else if layerNames.isEmpty {
            self = path.fill == .black ? .primary : .secondary
        } else if path.idChain.contains(layerNames[0]) {
            self = .primary
        } else if layerNames.count > 1, path.idChain.contains(layerNames[1]) {
            self = .secondary
        } else {
            self = .tertiary
        }
    }
}
