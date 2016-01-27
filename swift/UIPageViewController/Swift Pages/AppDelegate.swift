
import UIKit


import UIKit

class InstructionView: UIViewController
{
    
    var pageIndex : Int = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let label = UILabel(frame: CGRectMake(0, 0, view.frame.width, 200))
        label.textColor = UIColor.blueColor()
        label.text = "#" + String(pageIndex)
        label.textAlignment = .Center
        view.addSubview(label)
        view.backgroundColor = UIColor.greenColor()
    }
    
}

class PageViewController :UIPageViewController,UIPageViewControllerDataSource{
    required init(){
        super.init(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    }
    required  init?(coder: NSCoder){
        super.init(coder:coder)
    }
    override func viewDidLoad() {
        self.dataSource = self
        let startingViewController: InstructionView = viewControllerAtIndex(0)!
        let viewControllers = [startingViewController]
        setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! InstructionView).pageIndex
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index--
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        var index = (viewController as! InstructionView).pageIndex
        
        if index == NSNotFound {
            return nil
        }
        
        index++
        
        if (index == count) {
            return nil
        }
        
        return viewControllerAtIndex(index)
    }
    
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
    func viewControllerAtIndex(index: Int) -> InstructionView?
    {
        if count == 0 || index >= count
        {
            return nil
        }
        
        let pageContentViewController = InstructionView()
        pageContentViewController.pageIndex = index
        currentIndex = index
        
        return pageContentViewController
    }
    var count = 3
    var currentIndex : Int = 0
}



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
                            
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageControl.currentPageIndicatorTintColor = UIColor.blackColor()
        pageControl.backgroundColor = UIColor.blueColor()
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = PageViewController()
        self.window!.rootViewController!.view.backgroundColor = UIColor.whiteColor()
        self.window?.makeKeyAndVisible()
        return true

    }

   
}
