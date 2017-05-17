
## WebView

UIWebView用来在App内嵌入Web页面。如下代码装入Apple.com官方首页在App内:

    import UIKit
    class Page: UIViewController{
        var c : UIWebView!
        override func viewDidLoad() {
            super.viewDidLoad()
            c = UIWebView()
            c.frame = super.view.frame
            view.addSubview(c)
            c.frame.origin.y += 20
            let url = URL(string:"http://apple.com")
            let ro = URLRequest(url:url!)
            c.loadRequest(ro)
        }
    }
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

关键代码在于：

    let url = URL(string:"http://apple.com")
    let ro = URLRequest(url:url!)
    c.loadRequest(ro)

构建URL对象和URLRequest请求对象，然后使用WebView的方法loadRequest装入请求，即可加载页面在WebView内。

