//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// A rectangle that expresses a bounding box in absolute coordinates.
/// Get more info: https://www.figma.com/developers/api#rectangle-type
struct FigmaRectangle: Decodable, Hashable {

    // MARK: - Instance Properties

    /// X coordinate of top left corner of the rectangle.
    let x: Double?

    /// Y coordinate of top left corner of the rectangle.
    let y: Double?

    /// Width of the rectangle.
    let width: Double?

    /// Height of the rectangle.
    let height: Double?
}
