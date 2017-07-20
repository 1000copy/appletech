# Swift iOS ： 在webview的当前网页上提取信息的方法

使用UIWebView装载一个网页后，可能需要提取其内的信息，比较好的方法是使用JavaScript。方法UIWebView.stringByEvaluatingJavaScript可以执行一个脚本。

## 提取页面信息

执行如下代码，点击页面左上方的run js按钮，可以显示一个对话框，内容为当前网页的标题（title）：

    import UIKit
    class Page: UIViewController{
        var c : UIWebView!
        override func viewDidLoad() {
            super.viewDidLoad()
            c = UIWebView()
            c.frame = super.view.frame
            view.addSubview(c)
            c.frame.origin.y += 100
            c.frame.size.height = 300
            let url = URL(string:"http://apple.com")
            let ro = URLRequest(url:url!)
            c.loadRequest(ro)
            let button = UIButton()
            button.setTitle("run js", for: .normal)
            button.addTarget(self, action: #selector(tap), for: .touchDown)
            button.frame = CGRect(x: 0, y: 70, width: 100, height: 20)
            view.addSubview(button)
        }
        func tap(){
            c.stringByEvaluatingJavaScript(from: "function showtitle(){alert(document.title)};showtitle()")
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

如果javas使用的函数或者模块比较大，可以把它们放到一个文件内，作为资源包含，启动时加载并求值。这样是很方便的。接下来的案例，把上面案例的js函数showtitle()作为资源文件。首先func tap内修改为从资源中加载：

        func tap(){
            let jsCode = try! String(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "pack", ofType: "js")!))
            c.stringByEvaluatingJavaScript(from: jsCode)
            c.stringByEvaluatingJavaScript(from: "showtitle()")
        }
其次，创建一个资源文件，名为pack.js ,内容为：

      function showtitle(){alert(document.title)};

代码运行后，点击run js按钮，效果和前一个案例相同。

## 提取图片信息

有时候，需要截获WebView的手势操作到当前代码内，在此代码中获取当前手势触控的位置上的元素。这个场景下，就可以把js模块代码放到资源文件内，在触控代码中对此js调用和求值，获得它的输出：

    import UIKit
    class Page: UIViewController,UIGestureRecognizerDelegate{
        var c : UIWebView!
        var tapGesture : UITapGestureRecognizer!
        override func viewDidLoad() {
            super.viewDidLoad()
            c = UIWebView()
            c.frame = super.view.frame
            view.addSubview(c)
            c.frame.origin.y += 100
            c.frame.size.height = 300
            let url = URL(string:"https://httpbin.org/image/png")//must be a https url ,otherwise iOS will fobidden it 
            let ro = URLRequest(url:url!)
            c.loadRequest(ro)
            let button = UIButton()
            button.setTitle("run js", for: .normal)
            button.addTarget(self, action: #selector(tap), for: .touchDown)
            button.frame = CGRect(x: 0, y: 70, width: 100, height: 20)
            view.addSubview(button)
            tapGesture = UITapGestureRecognizer(target: self, action:#selector(tapHandler(_:)))
            self.tapGesture!.delegate = self
            self.c.addGestureRecognizer(self.tapGesture!);
        }
        func tap(){
            let jsCode = try! String(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "pack", ofType: "js")!))
            c.stringByEvaluatingJavaScript(from: jsCode)
            c.stringByEvaluatingJavaScript(from: "showtitle()")
        }
        func gestureRecognizer(_: UIGestureRecognizer,  shouldRecognizeSimultaneouslyWith shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool
        {
            return true
        }
        func tapHandler(_ tap :UITapGestureRecognizer){
            let tapPoint = tap.location(in: tap.view)
            print(tapPoint)
            let script = String(format: "getHTMLElementAtPoint(%i,%i)", Int(tapPoint.x),Int(tapPoint.y))
            let imgSrc = self.c.stringByEvaluatingJavaScript(from: script)
            print(imgSrc)
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
执行代码，点击页面的图片，就可以看到控制台上的输出：

    (168.0, 65.0)
    Optional("https://httpbin.org/image/png,100,100,110,0")

委托方法 gestureRecognizer(_:shouldRecognizeSimultaneouslyWith)是非常必要的，没有它的话，WebView会自己处理手势，而不是转移控制器给tapHandler(_:)。


