Swift默认的开发脚手架的代码看不下去。

要是改成这样：

    import abc
    @UIApplicationMain
    class App: AppBase {
        override func run(){
            super.run()
            MainPage = Page()
        }
    }
    
就很棒了。不但看不到ViewController，连UIKit都不需要引入了。

做法就是搞一个framework，名为abc，代码是这样的：

    import UIKit
    open class Page : UIViewController{
        
    }
    open  class AppBase: UIResponder, UIApplicationDelegate {
        public var window: UIWindow?
        public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
        {
            run()
            return true
        }
        open  func run(){
            window = UIWindow()
            window!.makeKeyAndVisible()
        }
        open var MainPage : UIViewController {
            get{
                return window!.rootViewController!
            }
            set (page){
                window!.rootViewController = page
                window!.rootViewController!.view.backgroundColor = .blue
            }
        }
        
    }
