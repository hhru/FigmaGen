//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// Rectangle node specific proprties.
/// Get more info: https://www.figma.com/developers/api#rectangle-props
struct FigmaRectangleNodePayload: Decodable, Hashable {

    // MARK: - Instance Properties

    /// Radius of each corner of the rectangle if a single radius is set for all corners.
    let cornerRadius: Double?

    /// Array of length 4 of the radius of each corner of the rectangle,
    /// starting in the top left and proceeding clockwise.
    let rectangleCornerRadii: [Double]?
}
