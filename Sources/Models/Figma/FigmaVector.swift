//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// A 2D vector.
/// Get more info: https://www.figma.com/developers/api#vector-type
struct FigmaVector: Decodable, Hashable {

    // MARK: - Instance Properties

    /// X coordinate of the vector.
    let x: Double

    /// Y coordinate of the vector.
    let y: Double
}
