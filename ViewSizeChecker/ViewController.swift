// -*- mode:swift -*-

import UIKit

class ViewController: UITableViewController {

    @IBOutlet weak var scaleValue: UILabel!
    @IBOutlet weak var horizontalValue: UILabel!
    @IBOutlet weak var verticalValue: UILabel!
    @IBOutlet weak var screenValue: UILabel!
    @IBOutlet weak var navigationBarValue: UILabel!
    @IBOutlet weak var tabBarValue: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateValues()
    }

    override func traitCollectionDidChange(
        previousTraitCollection: UITraitCollection) {
        updateValues()
    }

    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.All.toRaw())
    }

    // MARK: Private

    private func updateValues() {
        var s: NSString
        let tc = self.view.traitCollection
        scaleValue.text = "\(tc.displayScale)"
        horizontalValue.text = "\(tc.horizontalSizeClass)"
        verticalValue.text = "\(tc.verticalSizeClass)"

        s = NSStringFromCGSize(UIScreen.mainScreen().bounds.size)
        screenValue.text = s

        let n = self.navigationController!.navigationBar
        s = NSStringFromCGSize(n.frame.size)
        navigationBarValue.text = s

        let t = self.tabBarController!.tabBar
        s = NSStringFromCGSize(t.frame.size)
        tabBarValue.text = s
    }
}

extension UIUserInterfaceSizeClass: Printable {
    public var description: String {
        switch self {
        case .Compact:
            return "Compact"
        case .Regular:
            return "Regular"
        default:
            return "Unspecified"
        }
    }
}
