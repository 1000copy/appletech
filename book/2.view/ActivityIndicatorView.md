
## ActivityIndicatorView

UIActivityIndicatorView是一个特殊的视图，其外观就像菊花，可以让让旋转起来，以便指示当前有任务正在进行中。

案例代码显示一个ActivityIndicatorView，代码如下：

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

运行此代码，当你看到蓝色的背景和旋转的菊花形状，就说明代码已经正常工作。和一般的视图一样，加入的步骤也是：

1. 通过.addSubview方法，把它加入到父视图内
2. 通过设置frame，来设置此视图在它的父视图中的位置和大小

之后的视图添加到父视图的流程不再特别说明。

