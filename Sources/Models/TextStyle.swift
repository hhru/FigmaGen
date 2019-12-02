//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import Foundation

struct TextStyle: Hashable {

    // MARK: - Instance Properties

    let name: String

    let fontFamily: String
    let fontPostScriptName: String
    let fontWeight: Double
    let fontSize: Double

    let textColor: Color

    let paragraphSpacing: Double?
    let paragraphIndent: Double?
    let lineHeight: Double?
    let letterSpacing: Double?
}
