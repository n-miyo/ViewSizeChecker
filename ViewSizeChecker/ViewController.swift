// -*- mode:swift -*-

import UIKit

class ViewController: UITableViewController {

    @IBOutlet weak var scaleValueLabel: UILabel!
    @IBOutlet weak var horizontalValueLabel: UILabel!
    @IBOutlet weak var verticalValueLabel: UILabel!
    @IBOutlet weak var screenscaleValueLabel: UILabel!
    @IBOutlet weak var screenNativescaleValueLabel: UILabel!
    @IBOutlet weak var screenBoundsValueLabel: UILabel!
    @IBOutlet weak var screenNativeBoundsValueLabel: UILabel!
    @IBOutlet weak var navigationBarValueLabel: UILabel!
    @IBOutlet weak var tabBarValueLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = sysctlByName("hw.machine")
        updateValues()
    }

    override func viewWillTransitionToSize(
      size: CGSize,
      withTransitionCoordinator coordinator:
        UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(
          size, withTransitionCoordinator:coordinator)
        coordinator.animateAlongsideTransition(
          nil,
          completion: {
            context in
            self.updateValues()
        })
    }

    // MARK: Private

    private func updateValues() {
        let tc = self.view.traitCollection
        scaleValueLabel.text = "\(tc.displayScale)"
        horizontalValueLabel.text = "\(tc.horizontalSizeClass)"
        verticalValueLabel.text = "\(tc.verticalSizeClass)"

        let ms = UIScreen.mainScreen()
        screenscaleValueLabel.text = "\(ms.scale)"
        screenNativescaleValueLabel.text = "\(ms.nativeScale)"
        screenBoundsValueLabel.text = NSStringFromCGSize(ms.bounds.size)
        screenNativeBoundsValueLabel.text =
          NSStringFromCGSize(ms.nativeBounds.size)

        let n = navigationController!.navigationBar
        navigationBarValueLabel.text = NSStringFromCGSize(n.frame.size)

        let t = tabBarController!.tabBar
        tabBarValueLabel.text = NSStringFromCGSize(t.frame.size)
    }

    func sysctlByName(name: String) -> String {
        return name.withCString {
            cs in
            var s: UInt = 0
            sysctlbyname(cs, nil, &s, nil, 0)
            var v = [CChar](count: Int(s)/sizeof(CChar), repeatedValue: 0)
            sysctlbyname(cs, &v, &s, nil, 0)
            return String.fromCString(v)!
        }
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

// EOF
