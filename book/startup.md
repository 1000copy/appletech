尽管Xcode提供了不少UI设计的帮助，我还是希望一切还原到代码，这让我感到所以的编程秘密都在代码中，而不需要到UI中去寻求。这就是我创建这个最小app的原因。

具体的做法是这样的：

1. 打开xcode
2. 创建一个Single View App

Xcode会进入主要编辑界面。此时，我们打开APPDelegate文件然后覆盖源代码为如下代码：

        import UIKit
        @UIApplicationMain
        class AppDelegate: UIResponder, UIApplicationDelegate {
            var window: UIWindow?
            func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let page = UIViewController(nibName: nil, bundle: nil)
                page.view.backgroundColor = .blue
                self.window!.rootViewController = page
                self.window?.makeKeyAndVisible()
                return true
            }
        }

运行后，发现虚拟机内一片蓝色说明成功。

我们一起来看看代码。首先，所有app从继承UIApplicationDelegate开始，此类的子类必须标记为@UIApplicationMain，否者会报错Entry point(_main) undefined。

其次要说的是，Delegate是一个非常常用的概念，意味着“委托”。有了此技术，所有的事件可以在一个类内处理。AppDelegate类可以处理App的事件。我们看到的函数：

     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool 

正是一个UIApplicationDelegate事件。表明App完成启动。在此处，程序员可以做些App的启动代码工作。我们在此处创建了window实例，并把它的rootViewController设置为UIViewController的实例。

于是，代码从App Delegate到window再到UIViewController，完成了最基本的一个UI界面。接下来，我们会深入分析UIViewController，UIView，UIAppDelegate等类。




