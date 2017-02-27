# NavigationController

控制器NavigationController常用于用来做层次化UI导航。类名为UINavigationController。

NavigationController可以通过属性包含多个ViewController、一个UINavigationBar、一个可选的UIToolbar。

以一个共三层的ViewController的案例，来展示NavigationController的使用：

1. 共三层层次化UI
2. 每一级页面内有一个按钮，可以继续导航到下一级页面
3. 每一个页面的导航条的左侧按钮可以返还到上一级

代码如下：

        import UIKit
        @UIApplicationMain
        class AppDelegate: UIResponder, UIApplicationDelegate {
            var window: UIWindow?
            var nav : Nav?
            func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
                self.window = UIWindow(frame: UIScreen.main.bounds)
                nav = Nav()
                self.window!.rootViewController = nav
                self.window?.makeKeyAndVisible()
                return true
            }
        }
        class Nav: UINavigationController {
            var count = 0
            var label : UILabel!
            override func viewDidLoad() {
                super.viewDidLoad()
                self.view.backgroundColor = .white
                self.pushViewController(Level1(), animated: true)
            }
        }
        
        class Level1: UIViewController {
            var count = 0
            var label : UILabel!
            override func viewDidLoad() {
                super.viewDidLoad()
                self.title = "Level 1"
                        self.view.backgroundColor = .white
                        let button   = UIButton(type: .system)
                        button.frame = CGRect(x: 120, y: 100, width: 100, height: 50)
                        button.setTitle("Dive Into 2",for: .normal)
                        button.addTarget(self, action: #selector(Level1.buttonAction(_:)), for: .touchUpInside)
                        view.addSubview(button)
            }
            func buttonAction(_ sender:UIButton!){
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.nav?.pushViewController(Level2(), animated: true)
            }
        }
        
        class Level2: UIViewController {
            var count = 0
            var label : UILabel!
            override func viewDidLoad() {
                super.viewDidLoad()
                self.title = "Level 2"
                self.view.backgroundColor = .white
                let button   = UIButton(type: .system)
                button.frame = CGRect(x: 120, y: 100, width: 100, height: 50)
                button.setTitle("Dive Into 3",for: .normal)
                button.addTarget(self, action: #selector(Level2.buttonAction(_:)), for: .touchUpInside)
                view.addSubview(button)
            }
            func buttonAction(_ sender:UIButton!){
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.nav?.pushViewController(Level3(), animated: true)
            }
        }
        class Level3: UIViewController {
            var count = 0
            var label : UILabel!
            override func viewDidLoad() {
                super.viewDidLoad()
                self.title = "Level 3"
                self.view.backgroundColor = .white
                let button   = UIButton(type: .system)
                button.frame = CGRect(x: 120, y: 100, width: 100, height: 50)
                button.setTitle("End",for: .normal)
                button.addTarget(self, action: #selector(Level3.buttonAction(_:)), for: .touchUpInside)
                view.addSubview(button)
            }
            func buttonAction(_ sender:UIButton!){
                
            }
        }


解释下：

1. 把Nav作为UINavigationController的子类，实例化此类并设置到window.rootViewController上
2. 每一层都是继承于UIViewController，类名分别为Level1、Level2、Level3
3. Nav类视图加载完成后，把第一层Level1压入导航视图
4. 无需任何用户代码，UINavigationController本身默认提供页面的顶部条状区域，它被称为导航条(UINavigationBar)
5.  点击此导航条的左侧按钮可以返还到上一级页面；导航条中间显示当前ViewController的title属性值
