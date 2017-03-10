如果通过通过纯粹的代码，而不依赖于Xcode的StoryBoard，来完成一个App？

具体的做法是这样的：

1. 打开xcode
2. 创建一个Single View App

Xcode会进入主要编辑界面。此时，我们打开AppDelegate.swift文件然后覆盖源代码为如下代码：

        import UIKit
        @UIApplicationMain
        class AppDelegate: UIResponder, UIApplicationDelegate {
            var window : UIWindow?
            func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
                window = UIWindow()
                window!.rootViewController = UIViewController()
                window!.rootViewController!.view.backgroundColor = .blue
                window!.makeKeyAndVisible()
                return true
            }
        }

运行后发现手机（或者仿真器）满屏的蓝色背景就说明成功了。

我们一起来看看代码。

我们在此案例中将会接触到了UIAppDelegate、UIWindow、UIViewController、UIView等类，它们在概念上依次为应用委托、窗口、视图控制器、视图，

首先，查看AppDelegate类。它实现协议UIApplicationDelegate，且必须被标记为@UIApplicationMain，两者配合就设置了App的程序入口点，就像c语言的main函数一样。协议UIApplicationDelegate。AppDelegate实现了此协议中规定的函数：

     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool 

UIKit就会在完成App启动调用此函数。于是程序员在函数处可以实现自己的启动逻辑。

在本案例中，我们在启动函数中创建了window实例，它是UIWindow的实例。代码随即把window属性的rootViewController设置为UIViewController的实例。

为了可视化的看到我们的工作成果，我们设置UIViewController的背景色为蓝色，设置的方式就是把属性view背景色设置为蓝色，此属性是类UIView的实例。

这样，我们完成了最基本的一个UI界面。

window和view是构建UI的关键构造块，因此有必要澄清下概念。

每个应用都有一个window，这个window并没有任何外观形象，每个view都是被window包含在内的，事件处理也是首先路由到相应的window对象然后被导向到对应的视图。

View定义了一个屏幕上的矩形区域，并且管理此区域的内容和用户交互。window通过一个rootViewController的属性view开始关联，然后在此view内可以通过addSubView加入更多的子视图来完成UI的构建。

随后我们会接触更多的view类型，实际上按钮（UIButton）、标签（UILabel）等可以看到和交互的控件都是视图的子类,View的使用时非常广泛的。

还接触了一个被称为Delegate的设计模式。








设计的帮助，我还是希望一切还原到代码，这让我感到所以的编程秘密都在代码中，而不需要到UI中去寻求。

如果不做此标记，那么编译器会报错：“Entry point(_main) undefined”。