// -*- mode:swift -*-

import UIKit

class ViewController: UITableViewController {

    @IBOutlet weak var displayScaleLabel: UILabel!
    @IBOutlet weak var horizontalSizeLabel: UILabel!
    @IBOutlet weak var verticalSizeLabel: UILabel!
    @IBOutlet weak var screenScaleLabel: UILabel!
    @IBOutlet weak var screenNativeScaleLabel: UILabel!
    @IBOutlet weak var screenBoundsLabel: UILabel!
    @IBOutlet weak var screenNativeBoundsLabel: UILabel!
    @IBOutlet weak var navigationBarSizeLabel: UILabel!
    @IBOutlet weak var tabBarSizeLabel: UILabel!

    var hwMachine: String!
    var displayScale: String!
    var horizontalSize: String!
    var verticalSize: String!
    var screenScale: String!
    var screenNativeScale: String!
    var screenBounds: String!
    var screenNativeBounds: String!
    var navigationBarSize: String!
    var tabBarSize: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        hwMachine = sysctlByName("hw.machine")
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

    @IBAction func pressedActionButton(sender: UIBarButtonItem) {
        updateValues()
        let a: [String] = [
            "[\(hwMachine)]",
            "",
            "UITraitCollection:",
            "  displayScale: \(displayScale)",
            "  horizontalSize: \(horizontalSize)",
            "  verticalSize: \(verticalSize)",
            "",
            "UIScreen:",
            "  scale: \(screenScale)",
            "  nativeScale: \(screenNativeScale)",
            "  screenBounds: \(screenBounds)",
            "  nativeBounds: \(screenNativeBounds)",
            "",
            "MISC:",
            "  NavigationBar size: \(navigationBarSize)",
            "  TabBar size: \(tabBarSize)"
        ]
        var s = ""
        for x in a {
            s += "\(x)\n"
        }

        let avc =
          UIActivityViewController(activityItems:[s], applicationActivities:nil)
        avc.popoverPresentationController?.barButtonItem = sender
        navigationController!.presentViewController(
          avc, animated:true, completion:nil)
    }

    // MARK: Private

    private func updateViews() {
        updateValues()

        navigationItem.title = hwMachine

        displayScaleLabel.text = displayScale
        horizontalSizeLabel.text = horizontalSize
        verticalSizeLabel.text = verticalSize

        screenScaleLabel.text = screenScale
        screenNativeScaleLabel.text = screenNativeScale
        screenBoundsLabel.text = screenBounds
        screenNativeBoundsLabel.text = screenNativeBounds

        navigationBarSizeLabel.text = navigationBarSize
        tabBarSizeLabel.text = tabBarSize
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
        navigationBarSize = NSStringFromCGSize(n.frame.size)

        let t = tabBarController!.tabBar
        tabBarSize = NSStringFromCGSize(t.frame.size)
    }

    private func sysctlByName(name: String) -> String {
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
