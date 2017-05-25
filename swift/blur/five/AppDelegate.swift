import UIKit
import FXBlurView
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow();
        self.window?.frame=UIScreen.main.bounds;
        self.window?.makeKeyAndVisible();
        self.window?.rootViewController = Page()
        return true
    }
}
class Page: UIViewController {
    var backgroundImageView:UIImageView?
    var frostedView = FXBlurView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundImageView = UIImageView()
        self.backgroundImageView!.frame = self.view.frame
        self.backgroundImageView!.contentMode = .scaleToFill
        view.addSubview(self.backgroundImageView!)
        frostedView.underlyingView = self.backgroundImageView!
        frostedView.isDynamic = true
        frostedView.tintColor = UIColor.black
        frostedView.frame = self.view.frame
        self.view.addSubview(frostedView)
        self.backgroundImageView?.image = UIImage(named: "1.jpg")
        self.frostedView.updateAsynchronously(true, completion: nil)
    }
}
