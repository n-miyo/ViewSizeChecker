// -*- mode:swift -*-

import UIKit

class ViewController: UITableViewController {

    @IBOutlet weak var scaleValue: UILabel!
    @IBOutlet weak var horizontalValue: UILabel!
    @IBOutlet weak var verticalValue: UILabel!
    @IBOutlet weak var screenScaleValue: UILabel!
    @IBOutlet weak var screenNativeScaleValue: UILabel!
    @IBOutlet weak var screenBoundsValue: UILabel!
    @IBOutlet weak var screenNativeBoundsValue: UILabel!
    @IBOutlet weak var navigationBarValue: UILabel!
    @IBOutlet weak var tabBarValue: UILabel!

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
        scaleValue.text = "\(tc.displayScale)"
        horizontalValue.text = "\(tc.horizontalSizeClass)"
        verticalValue.text = "\(tc.verticalSizeClass)"

        let ms = UIScreen.mainScreen()
        screenScaleValue.text = "\(ms.scale)"
        screenNativeScaleValue.text = "\(ms.nativeScale)"
        screenBoundsValue.text = NSStringFromCGSize(ms.bounds.size)
        screenNativeBoundsValue.text = NSStringFromCGSize(ms.nativeBounds.size)

        let n = navigationController!.navigationBar
        navigationBarValue.text = NSStringFromCGSize(n.frame.size)

        let t = tabBarController!.tabBar
        tabBarValue.text = NSStringFromCGSize(t.frame.size)
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
