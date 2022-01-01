/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The app delegate.
*/

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let split = window?.rootViewController as? UISplitViewController,
            let nav = split.viewControllers[split.viewControllers.count - 1] as? UINavigationController,
            let detail = nav.topViewController {
            
            detail.navigationItem.leftBarButtonItem = split.displayModeButtonItem
            split.delegate = self
        }
        
        return true
    }

    // MARK: - Split view

    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? AccessoryView else { return false }
        if topAsDetailController.accessory == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }

}

