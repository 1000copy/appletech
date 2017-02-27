基于之前提到的脚手架，我们再次创建一个swift app，这次做点小东西：

1. 界面包括一个按钮和一个标签，标签初始值为0
2. 当点击按钮时，标签的数字会被累加1

代码如下：

        import UIKit
        @UIApplicationMain
        class AppDelegate: UIResponder, UIApplicationDelegate {
            var window: UIWindow?
            func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let page = Page1()
                self.window!.rootViewController = page
                self.window?.makeKeyAndVisible()
                return true
            }
        }
        class Page1: UIViewController {
            var count = 0
            var label : UILabel!
            override func viewDidLoad() {
                super.viewDidLoad()
                self.view.backgroundColor = .white
                label   = UILabel()
                label.frame = CGRect(x: 100, y: 100, width: 20, height: 50)
                label.text =  "0"
                view.addSubview(label)
                let button   = UIButton(type: .system)
                button.frame = CGRect(x: 120, y: 100, width: 20, height: 50)
                button.setTitle("+",for: .normal)
                button.addTarget(self, action: #selector(Page1.buttonAction(_:)), for: .touchUpInside)
                view.addSubview(button)
            }
            func buttonAction(_ sender:UIButton!){
                self.count +=  1
                label.text =  self.count.description
            }
        }


编译运行后会看到界面上的按钮和标签，点击按钮标签的值加1，说明App满足我们的最初需求。

代码解释下：
1. 这次设置为APPDelegate内的rootViewController为一个继承与UIViewController的类
2. UIViewController类内属性view可以把其他view加入其内，
3. 按钮的类为UIButton ,可以通过属性frame设置位置和大小，可以通过UIViewController.view对象的方法addSubview把按钮加入到UIViewController内
3. 标签的类为UILabel，可以通过属性frame设置位置和大小，可以通过UIViewController.view对象的方法addSubview把按钮加入到UIViewController内
4. button可以添加事件，通过方法：

          button.addTarget(self, action: #selector(Page1.buttonAction(_:)), for: UIControlEvents.touchUpInside)
          


