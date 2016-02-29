import UIKit

// Alert View
class DemoAlertViewOfUIAlertController:UIViewController{
    override func viewDidAppear(animated: Bool) {
        Alert()
    }
    func Alert(){
        let alert = UIAlertController(title: "Hi", message: "I am message", preferredStyle:.Alert)
        // Closure
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
            print("OK")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler:nil))
        AppDelegate.Top?.presentViewController(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
    }

}


// Action Sheet
class DemoActionSheetOfUIAlertController:UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
    }
    override func viewDidAppear(animated: Bool) {
        ActionSheet()
    }
    func ActionSheet() {
        let sheet: UIAlertController = UIAlertController(title:nil, message:nil, preferredStyle:UIAlertControllerStyle.ActionSheet)
        sheet.addAction(UIAlertAction(title:"Do something 1", style:UIAlertActionStyle.Default, handler:{ action in
            print ("Do something 1")
        }))
        sheet.addAction(UIAlertAction(title:"Do something 2", style:UIAlertActionStyle.Default, handler:{ action in
            print ("Do something 2")
        }))
        sheet.addAction(UIAlertAction(title:"Cancel", style:UIAlertActionStyle.Cancel, handler:nil))
        AppDelegate.Top?.presentViewController(sheet, animated:true, completion:nil)
    }
}



class PageViewController :UIPageViewController,UIPageViewControllerDataSource{
    var vcs :[UIViewController]
    required init(){
        vcs = [DemoActionSheetOfUIAlertController(),DemoAlertViewOfUIAlertController()]
        super.init(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    }
    required  init?(coder: NSCoder){
        fatalError()
    }
    override func viewDidAppear(animated: Bool) {
        setViewControllers([vcs[0]], direction: .Forward, animated: false, completion: nil)
        
    }
    override func viewDidLoad() {
        self.dataSource = self

    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        let v = (viewController)
        let i = vcs.indexOf(v)! - 1
        if i < 0 {
            return nil
        }
        return vcs[i]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        let v = (viewController)
        let i = vcs.indexOf(v)! + 1
        if i > vcs.count - 1 {
            return nil
        }
        return vcs[i]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return vcs.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = PageViewController()
        self.window?.makeKeyAndVisible()
        return true
    }
    //http://pinkstone.co.uk/how-to-avoid-whose-view-is-not-in-the-window-hierarchy-error-when-presenting-a-uiviewcontroller/
   func topMost ()-> UIViewController?{
        var  top = UIApplication.sharedApplication().keyWindow?.rootViewController!
        while top?.presentedViewController != nil{
            top = top!.presentedViewController
        }
        return top
    }
    class var Top :  UIViewController?{
        get {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).topMost()
        }
    }
}