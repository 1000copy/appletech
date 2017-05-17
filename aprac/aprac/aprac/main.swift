 import UIKit
 open class Page : UIViewController{
    open func loaded(){
    
    }
    open override func viewDidLoad() {
        loaded()
    }
 }
 open  class AppBase: UIResponder, UIApplicationDelegate {
    public var window: UIWindow?
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        run()
        MainPage = main() as! UIViewController
        return true
    }
    func run(){
        window = UIWindow()
        window!.makeKeyAndVisible()
    }
    open  func main() -> Any{
        return Page()
    }
    var MainPage : UIViewController {
        get{
            return window!.rootViewController!
        }
        set (page){
            window!.rootViewController = page
        }
    }
    
 }
 public class Image : UIImage{
    public class func block(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 10.0,height: 10.0 )
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
 }
 
 public class Nav: UINavigationController {
    var count = 0
    var pages : [Page] = []
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public init(_ pages : [Page]) {
        self.pages = pages
        super.init(rootViewController:pages[0])
    }
    open func loaded(){
        
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
//        self.pushViewController(pages[0], animated: true)
        loaded()
    }
 }
