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
    var t : String?
    open var touch : String{
        get{return ""}
        set(value){
            addTarget(parent, action: Selector(value), for: .touchUpInside)
        }
    }
    var r : [Int]?
    open var rect : [Int]?{
        get{return r}
        set(value){
            r = value
            setFrame(r![0], r![1],r![2],r![3])
        }
    }
    open var title : String?{
        get{return t}
        set(value){
            t = value
            setTitle(value,for: .normal)
        }
    }
    
    open var parent : Page{
        get{return p!}
        set(value){
            self.p = value
        }
    }
    public func setFrame(_ x: Int, _  y: Int, _  width: Int, _  height: Int){
        frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
    
 }
 open class MultiPage :UIPageViewController,UIPageViewControllerDataSource{
//    var vcs :[UIViewController]     
    public required init(){
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    public required  init?(coder: NSCoder){
        fatalError()
    }
    open func Pages() ->[Page]{
        return []
    }
    var vcs : [Page]?
    open override func viewDidLoad() {
        vcs = Pages()
        self.dataSource = self
        setViewControllers( [vcs![0]], direction: .forward, animated: false, completion: nil)
    }
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        let v = (viewController as! Page)
        let i = vcs!.index(of: v)! - 1
        if i < 0 {
            return nil
        }
        return vcs![i]
    }
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        let v = (viewController as! Page)
        let i = vcs!.index(of: v)! + 1
        if i > vcs!.count - 1 {
            return nil
        }
        return vcs![i]
    }
    public func presentationCount(for pageViewController: UIPageViewController) -> Int
    {
        return vcs!.count
    }
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
 }
