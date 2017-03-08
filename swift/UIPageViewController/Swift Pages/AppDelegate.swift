import UIKit
class VCBase: UIViewController
{
    
    var label : UILabel?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        label!.textAlignment = .center
        view.addSubview(label!)
        view.backgroundColor = UIColor.white
    }
}
class Page1: VCBase
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        label!.text = "#1"
    }
}
class Page2: VCBase
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        label!.text = "#2"
    }
}
class PageViewController :UIPageViewController,UIPageViewControllerDataSource{
    var vcs :[UIViewController]
    required init(){
        vcs = [Page1(),Page2()]
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    required  init?(coder: NSCoder){
        fatalError()
    }
    override func viewDidLoad() {
        self.dataSource = self
        setViewControllers( [vcs[0]], direction: .forward, animated: false, completion: nil)
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        let v = (viewController)
        let i = vcs.index(of: v)! - 1
        if i < 0 {
            return nil
        }
        return vcs[i]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        let v = (viewController)
        let i = vcs.index(of: v)! + 1
        if i > vcs.count - 1 {
            return nil
        }
        return vcs[i]
    }
    func presentationCount(for pageViewController: UIPageViewController) -> Int
    {
        return vcs.count
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.rootViewController = PageViewController()
        self.window?.makeKeyAndVisible()
        return true
    }
}
