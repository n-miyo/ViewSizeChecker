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

    var displayScale: String!
    var horizontalSize: String!
    var verticalSize: String!
    var screenScale: String!
    var screenNativeScale: String!
    var screenBounds: String!
    var screenNativeBounds: String!
    var navigationBarFrame: String!
    var tabBarFrame: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = sysctlByName("hw.machine")
        updateViews()
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
            self.updateViews()
        })
    }

    // MARK: Private

    private func updateViews() {
        updateValues()

        scaleValueLabel.text = displayScale
        horizontalValueLabel.text = horizontalSize
        verticalValueLabel.text = verticalSize

        screenscaleValueLabel.text = screenScale
        screenNativescaleValueLabel.text = screenNativeScale
        screenBoundsValueLabel.text = screenBounds
        screenNativeBoundsValueLabel.text = screenNativeBounds

        navigationBarValueLabel.text = navigationBarFrame
        tabBarValueLabel.text = tabBarFrame
    }

    private func updateValues() {
        let tc = self.view.traitCollection
        displayScale = "\(tc.displayScale)"
        horizontalSize = "\(tc.horizontalSizeClass)"
        verticalSize = "\(tc.verticalSizeClass)"

        let ms = UIScreen.mainScreen()
        screenScale = "\(ms.scale)"
        screenNativeScale = "\(ms.nativeScale)"
        screenBounds = NSStringFromCGSize(ms.bounds.size)
        screenNativeBounds = NSStringFromCGSize(ms.nativeBounds.size)

        let n = navigationController!.navigationBar
        navigationBarFrame = NSStringFromCGSize(n.frame.size)

        let t = tabBarController!.tabBar
        tabBarFrame = NSStringFromCGSize(t.frame.size)
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
