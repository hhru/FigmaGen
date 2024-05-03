import Foundation
import FigmaGenTools

struct BaseConfiguration: Decodable {

    // MARK: - Instance Properties

    let file: FileConfiguration?
    let accessToken: AccessTokenConfiguration?
}
