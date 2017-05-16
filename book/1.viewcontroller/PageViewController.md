
## PageViewController

PageViewController可以管理多个页面，每个页面都是一个ViewController，可以使用程序控制或者用户手势来切换页面。

我们来看案例。案例App外观和交互描述如下：

1. App共有两个页面
2. 默认进来的是Page1类实例代表的页面，此页面内有一个标签，标签显示为"#1",
3. 另外一个页面是Page2类实例代表的页面，此页面内有一个标签，标签显示为"#2"
4. 可以使用手势（左划和右划）切换也的显示两个页面
5. 屏幕下方有一个蓝色背景的矩形，内有两个圆点，一个白色一个灰色，当切换页面时，圆点会切换颜色，以便指示当前页面

如下代码，展示了PageViewController的使用：

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
            self.window!.rootViewController!.view.backgroundColor = .blue
            self.window?.makeKeyAndVisible()
            return true
        }
    }

此处代码的前两个类Page1，Page2都是UIViewController的子类，每个初始化一个标签（UILabel），标签的内容是不同的，以示两个页面的区别。类PageViewController是UIPageViewController的子类，实现了UIPageViewControllerDataSource并在装入时设置数据源为自身。通过：

         setViewControllers( [vcs[0]], direction: .forward, animated: false, completion: nil)
         
设置PageViewController的当前的ViewController，值为Page1的实例，因此App启动后显示的初始页面就是Page1。

协议UIPageViewControllerDataSource的内容如下：

        public protocol UIPageViewControllerDataSource : NSObjectProtocol {
            public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
            public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
            optional public func presentationCount(for pageViewController: UIPageViewController) -> Int 
            optional public func presentationIndex(for pageViewController: UIPageViewController) -> Int 
        }
其中前两个函数会由UIKit传入当前视图，希望App返回此视图的前一个视图或者是后一个视图。后两个函数分别返回总页面数量和初始页面对应的选择项索引，这两个函数是可选实现的，如果实现了，就会在页面底部显示页面指示器，也就是我们最早提到的，在屏幕下方显示的两个圆点。

