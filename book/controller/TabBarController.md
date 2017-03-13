
## TabBarController

类UITabBarController是一个特殊的UIViewController，它可以包含多个UIViewController，并且在页面底部显示一个Tabbar作为UIViewController的切换显示开关。

如下案例，展示了包含两个UIViewController的UITabBarController，可以通过底部的Tabbar来切换显示：

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

可以点击屏幕显示的下方按钮切换视图控制器。

本案例中，共有三个需要关注的类：
1. Page1，Page2。都是UIViewController的子类，内含一个UILabel区别显示为Page #1，Page #2 
2. Tabbar 是UITabBarController的子类，实现协议UITabBarControllerDelegate，并在viewDidLoad时设置委托到自身；属性viewControllers是一个数组，用于装入多个UIViewController的实例，当执行：

        func viewWillAppear(_ animated: Bool)
        
初始化此数组，创建需要选择的UIViewController实例进来。


Tabbar就是一个UIViewController的子类，因此可以把它设置到self.window!.rootViewController上，从而成为window的rootViewController。

