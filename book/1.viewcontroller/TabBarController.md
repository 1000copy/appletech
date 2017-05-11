
## TabBarController

类UITabBarController是一个特殊的UIViewController，它可以包含多个UIViewController的实例，并且在页面底部显示一个Tabbar作为UIViewController的切换显示开关。

如下案例，展示了包含两个ViewController的UITabBarController的使用方法。可以通过底部的Tabbar来切换显示：

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
    
可以点击屏幕显示的下方按钮切换视图控制器。

本案例中，共有三个需要关注的类：

1. Page1。UIViewController的子类，内含一个UILabel,显示字符串为Page #1
2. Page2。UIViewController的子类，内含一个UILabel,显示字符串为Page #2 
3. Tabbar是UITabBarController的子类，实现协议UITabBarControllerDelegate，并在viewDidLoad时设置委托到自身；其属性viewControllers是一个数组，用于装入多个UIViewController的实例，当执行：

        func viewWillAppear(_ animated: Bool)
        
初始化此数组，创建需要选择的UIViewController实例进来即可。

可以把Tabbar的实例它赋值给self.window!.rootViewController上，这样就把它设置为App的根视图控制器了。





