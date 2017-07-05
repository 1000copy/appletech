老版本的Swift（小于2.2），想要给Button一个事件的话，需要用到Selector函数，像是这样：

    import UIKit
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        var window : UIWindow?
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            window = UIWindow()
            window!.rootViewController = UIViewController()
            let button = UIButton()
            button.frame = CGRect(x: 10, y: 10, width: 100, height: 20)
            button.setTitle("Touch", for: .normal)
            button.addTarget(self, action: Selector("touched:"), for: .touchDown)
            window!.rootViewController!.view.addSubview(button)
            window!.rootViewController!.view.backgroundColor = .blue
            window!.makeKeyAndVisible()
            return true
        }
        func touched(_ sender : UIButton){
            print("touched")
        }
    }
当然，这个代码可以运行，也可以如愿的在点击按钮后，打印一个
    
    touched
    
字符串来。但是这样的代码是无法使用编译检查的，就是说，如果：
    
    Selector("touched:")

内的字符串写出别的什么并不存在的函数的话，也是可以编译通过的，但是在运行时就无法被期望是正确的了。

于是#selector就被引入进来。同样的功能，可以修改为：

    #selector(touched(_:))

不但touched函数名称会被检查，包括参数在内也会被检查，如果参数数量不够，或者参数标签对不上，也是无法通过编译的。这样就把发现问题的时机从运行期提前到编译器了。

当然有人还是会觉得，这样的代码太啰嗦：

   
   
    button.addTarget(self, action:  #selector(touched(_:)), for: .touchDown)

于是也有人提出一个比较有趣的方法，就是使用扩展（extention），让#selector隐藏在扩展（Selector）内：

    fileprivate extension Selector  {
        static let touch =
            #selector(AppDelegate.touched(_:))
    }
    import UIKit
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        var window : UIWindow?
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            window = UIWindow()
            window!.rootViewController = UIViewController()
            let button = UIButton()
            button.frame = CGRect(x: 10, y: 10, width: 100, height: 20)
            button.setTitle("Touch", for: .normal)
            button.addTarget(self, action: .touch, for: .touchDown)
            window!.rootViewController!.view.addSubview(button)
            window!.rootViewController!.view.backgroundColor = .blue
            window!.makeKeyAndVisible()
            return true
        }
        func touched(_ sender : UIButton){
            print("touched")
        }
    }

于是，在使用时就可以写成这样了：

    button.addTarget(self, action: .touch, for: .touchDown)

竟然是有些耳目一新的感觉了。
