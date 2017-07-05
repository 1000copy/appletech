类NotificationCenter提供了一种轻耦合的消息传递机制。可以发起一个通知，在多处监听此通知。比如说一个App的主题样式被修改，就可以通过此类来通知多个相关UI，做响应的处理。

如下案例展示了这种可能：

    import UIKit
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        var window: UIWindow?
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            self.window = UIWindow();
            self.window?.frame=UIScreen.main.bounds;
            self.window?.makeKeyAndVisible();
            NotificationCenter.default.addObserver(self, selector: #selector(themeChange), name: Notification.Name("themeChange"), object: nil)
            self.window?.rootViewController = Page()
            return true
        }
        func themeChange(){
            print("themeChange2")
        }
    }
    class Page: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .blue
            NotificationCenter.default.addObserver(self, selector: #selector(themeChange), name: Notification.Name("themeChange"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(themeChange1), name: Notification.Name("themeChange"), object: nil)
            NotificationCenter.default.post(name: Notification.Name("themeChange"), object: nil)
        }
        func themeChange(){
            print("themeChange")
        }
        func themeChange1(){
            print("themeChange1")
        }
    }

执行此代码，输出应该是：

    themeChange2
    themeChange
    themeChange1

通过 NotificationCenter.default.addObserver在类Page1做了两处对“themeChange”通知的监听，在类AppDelegate做了一处对此通知的监听。然后当：
    
    NotificationCenter.default.post(name: Notification.Name("themeChange"), object: nil)

执行时，三处监听函数都会被调用。
NotificationCenter还可以监听系统通知，比如App进入前景和背景，按如下方法监听即可：

    import UIKit
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        var window: UIWindow?
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            self.window = UIWindow();
            self.window?.frame=UIScreen.main.bounds;
            self.window?.makeKeyAndVisible();
            self.window?.rootViewController = Page()
            return true
        }
    }
    class Page: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .blue
            NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        }
        func applicationWillEnterForeground(){
            print("applicationWillEnterForeground")
        }
        func applicationDidEnterBackground(){
            print("applicationDidEnterBackground")
        }
    }

应用执行后，按HOME按钮，可以看到输出：
    
    applicationDidEnterBackground

再度执行App可以看到输出：
    
    applicationWillEnterForeground
    
可以传递和接受对象作为参数，像是这样传递：

    let cd = {(_ a : String) in print(a)}
    NotificationCenter.default.post(name: Notification.Name("dive2"), object: [1,"2",cd])

像是这样接收：

    func dive2(_ obj : Any){
            nav?.pushViewController(Level2(), animated: true)
            print(obj)
    //        {name = dive2; object = (
    //        1,
    //        2,
    //        "(Function)"
    //        )}
    
        }
