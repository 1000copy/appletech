import UIKit
class Page1: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let cc = UILabel(frame: CGRect(x: 10,y: 50,width: 200,height: 50))
        cc.text = "Page #1"
        cc.textColor = UIColor.black
        self.view.addSubview(cc)
    }
}
class Page2: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let cc = UILabel(frame: CGRect(x: 10,y: 50,width: 200,height: 50))
        cc.text = "Page #2"
        cc.textColor = UIColor.black
        self.view.addSubview(cc)
    }
}
class Tabbar: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewControllers = [Page1(),Page2()]
        let r = UIImage.imageWithColor(UIColor.black)
        viewControllers![0].tabBarItem = UITabBarItem(title: "Page 1",
                        image:r,
            tag:0)
        viewControllers![1].tabBarItem = UITabBarItem(title: "Page 2",
            image: r,
             tag:1)

    }
    
    //Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("did select viewController: \(viewController.tabBarItem.tag)")
    }
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.rootViewController = Tabbar()
        self.window!.rootViewController!.view.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        return true
    }
}
// same code
extension UIImage {
    class func imageWithColor(_ color: UIColor) -> UIImage {
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
//let r = UIImage.imageWithColor(UIColor.redColor()).imageWithRenderingMode(.AlwaysOriginal)
//let b = UIImage.imageWithColor(UIColor.blueColor()).imageWithRenderingMode(.AlwaysOriginal)
