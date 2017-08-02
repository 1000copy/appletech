SVG文件是矢量图标准之一，特点是可以缩放，并且可以用可以阅读的源代码的方式（而不是二进制）来存储图形信息。比如如下文件就是一个svg文件：

    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 350 100">
      <defs>
        <marker id="arrowhead" markerWidth="10" markerHeight="7" 
        refX="0" refY="3.5" orient="auto">
          <polygon points="0 0, 10 3.5, 0 7" />
        </marker>
      </defs>
      <line x1="0" y1="50" x2="250" y2="50" stroke="#000" 
      stroke-width="8" marker-end="url(#arrowhead)" />
    </svg>

它是一个箭头图。可以使用UIWebView视图加载此文件并显示。首先把SVG文件作为资源文件加入工程，命名为1.svg。

其实，使用如下代码加载此文件：

        var path: String = Bundle.main.path(forResource: "1", ofType: "svg")!
        var url: NSURL = NSURL.fileURL(withPath: path) as NSURL
        var request: NSURLRequest = NSURLRequest(url: url as URL)
        webview?.loadRequest(request as URLRequest)

完整代码如下：

      import UIKit
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        var window: UIWindow?
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let page = Page()
            page.view.backgroundColor = .blue
            self.window!.rootViewController = page
            self.window?.makeKeyAndVisible()
            return true
        }
    }
    class Page: UIViewController {
        var count = 0
        var webview : UIWebView!
        var webview1 : UIWebView!
        override func viewDidLoad() {
            super.viewDidLoad()
            webview = UIWebView()
            webview?.frame = CGRect(x: 0, y: 100, width: 100, height: 100)
            view.addSubview(webview!)
            webview1 = UIWebView()
            webview1.frame = CGRect(x: 0, y: 200, width: 50, height: 50)
            view.addSubview(webview1!)
            let path: String = Bundle.main.path(forResource: "1", ofType: "svg")!
            let url: NSURL = NSURL.fileURL(withPath: path) as NSURL
            let request: NSURLRequest = NSURLRequest(url: url as URL)
            webview?.loadRequest(request as URLRequest)
            webview1.loadRequest(request as URLRequest)
        }
    }

本意是想用它来替换位图图标，但是看起来加载速度堪忧。