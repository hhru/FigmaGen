//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// A position color pair representing a gradient stop.
/// Get more info: https://www.figma.com/developers/api#colorstop-type
struct FigmaColorStop: Decodable, Hashable {

    // MARK: - Instance Properties

    /// Value between 0 and 1 representing position along gradient axis.
    let position: Double

    /// Color attached to corresponding position.
    let color: FigmaColor
}
