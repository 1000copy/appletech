        import UIKit
        @UIApplicationMain
        class AppDelegate: UIResponder, UIApplicationDelegate {
            var window : UIWindow?
            func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
                window = UIWindow()
                window!.rootViewController = UIViewController()
                window!.rootViewController!.view.backgroundColor = .blue
                window!.makeKeyAndVisible()
                return true
            }
        }
