//
// FigmaGen
// Copyright © 2019 HeadHunter
// MIT Licence
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.attributedText = "Title".styled(.title2, textColor: Colors.black)
        subtitleLabel.attributedText = "Subtitle".styled(.subtitle2, textColor: Colors.gray)
    }
}
