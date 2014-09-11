// -*- mode:swift -*-

import UIKit

class TabBarController: UITabBarController {
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.All.toRaw())
    }
}
