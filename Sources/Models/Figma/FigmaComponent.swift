//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

/// A description of a master component.
/// Helps you identify which component instances are attached to.
/// Get more info: https://www.figma.com/developers/api#component-type
struct FigmaComponent: Decodable, Hashable {

    // MARK: - Instance Properties

    /// The key of the component.
    let key: String

    /// The name of the component.
    let name: String

    /// The description of the component as entered in the editor.
    let description: String?
}
