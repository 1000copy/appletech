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
    public class var gate : UIApplicationDelegate {
        get{
            return UIApplication.shared.delegate!
        }
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
 
 open class Nav: UINavigationController {
    open func loaded(){
        
    }
    open var homePage:Page{
        get {
    
        return Page()
        }
    }
    open func push(_ p : Page){
        self.pushViewController(p, animated: true)
    }
    open func pop(){
        self.popViewController(animated: true)
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        push(homePage)
        loaded()
    }
 }

 public func Frame(_ x: Int, _  y: Int, _  width: Int, _  height: Int) -> CGRect{
    return CGRect(x: x, y: y, width: width, height: height)
 }
 
 
 public class Button : UIButton{
    var p : Page?
    open var touch : String{
        get{return ""}
        set(value){
            addTarget(parent, action: Selector(value), for: .touchUpInside)
        }
    }
    open var parent : Page{
        get{return p!}
        set(value){
            self.p = value
        }
    }
    
 }
