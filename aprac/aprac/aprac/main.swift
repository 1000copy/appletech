 import UIKit
 open class Page : UIViewController{
    
 }
 open  class AppBase: UIResponder, UIApplicationDelegate {
    public var window: UIWindow?
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        run()
        MainPage = main()
        return true
    }
    open  func run(){
        window = UIWindow()
        window!.makeKeyAndVisible()
    }
    open  func main() -> Page{
        return Page()
    }
    
    open var MainPage : UIViewController {
        get{
            return window!.rootViewController!
        }
        set (page){
            window!.rootViewController = page
//            window!.rootViewController!.view.backgroundColor = .blue
        }
    }
    
 }
