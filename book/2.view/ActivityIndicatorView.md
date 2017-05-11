
## ActivityIndicatorView

UIActivityIndicatorView就像一朵旋转的菊花，它常常用来指示有任务正在进行中。

代码展示了它的使用：

    import UIKit
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        var window: UIWindow?
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window!.rootViewController = Page()
            self.window?.makeKeyAndVisible()
            return true
        }
    }
    class Page :UIViewController{
        var v : UIActivityIndicatorView?
        override func viewDidLoad() {
            v = UIActivityIndicatorView()
            v!.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
            view.addSubview(v!)
            view.backgroundColor = .blue
        }
        override func viewDidAppear(_ animated: Bool) {
            v!.startAnimating()
        }
        override func viewDidDisappear(_ animated: Bool) {
            v!.stopAnimating()
        }
    }

运行此代码，当你看到蓝色的背景和旋转的菊花形状，就说明代码已经正常工作。