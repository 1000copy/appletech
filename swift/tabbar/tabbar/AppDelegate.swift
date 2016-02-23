import UIKit
class vc1: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let cc = UILabel(frame: CGRectMake(10,50,200,50))
        cc.text = "#1"
        cc.textColor = UIColor.blackColor()
        self.view.addSubview(cc)
    }
}
class vc2: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let cc = UILabel(frame: CGRectMake(10,50,200,50))
        cc.text = "#2"
        cc.textColor = UIColor.blackColor()
        self.view.addSubview(cc)
    }
}
class Tabbar: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        viewControllers = [vc1(),vc2()]
        let r = UIImage.imageWithColor(UIColor.blackColor())
        viewControllers![0].tabBarItem = UITabBarItem(title: "Title1",
                        image:r,
            tag:0)
        viewControllers![1].tabBarItem = UITabBarItem(title: "Title2",
            image: r,
             tag:1)

    }
    
    //Delegate methods
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        print("did select viewController: \(viewController.tabBarItem.tag)")
    }
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = Tabbar()
        self.window!.rootViewController!.view.backgroundColor = UIColor.whiteColor()
        self.window?.makeKeyAndVisible()
        return true
    }
}
// same code
extension UIImage {
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, 10.0,10.0 )
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
//let r = UIImage.imageWithColor(UIColor.redColor()).imageWithRenderingMode(.AlwaysOriginal)
//let b = UIImage.imageWithColor(UIColor.blueColor()).imageWithRenderingMode(.AlwaysOriginal)
