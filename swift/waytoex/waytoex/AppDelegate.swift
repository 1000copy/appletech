import UIKit
import MJRefresh
import Kingfisher
import ObjectMapper
import Ji
import YYText
import KeychainSwift
import SnapKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        let nav = UINavigationController()
        window!.rootViewController = nav
        nav.pushViewController(Page(), animated: true)
        //        window!.rootViewController = Page()
        window!.rootViewController!.view.backgroundColor = .blue
        window!.makeKeyAndVisible()
        return true
    }
}
