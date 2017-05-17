
## ScrollView

UIScrollView支持显示尺寸比控件更大的内容。允许用户通过手势来滑动内容，以便显示本来看不到的内容。

如下代码展示了UIScrollView的功能：

    import UIKit
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        var window: UIWindow?
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window!.rootViewController = Page()
            self.window?.makeKeyAndVisible()
            return true
        }
    }
    class Page: UIViewController {
        var scroll: UIScrollView!
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = UIColor.white
            self.scroll = UIScrollView()
            scroll.backgroundColor = UIColor.red
            self.scroll.contentSize = CGSize(width: 100, height: 300)
            scroll.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
            for i in 0  ..< 3 {
                let b = UILabel()
                b.backgroundColor = UIColor.blue
                b.frame = CGRect(x: 0, y: CGFloat(100 * i) , width: 100, height: 100)
                b.backgroundColor = UIColor.green
                b.text = "Drag Me ! "
                scroll.addSubview(b)
            }
            view.addSubview(scroll)
        }
    }

运行后，你可以看到一个绿色的矩形框，以及框内的一个文字。其实文字框共有三个，但是你只能看到一个。你可以通过手势，或者如果在模拟器内，你可以使用鼠标向上拖动，把本来因为控件比内容小而不得不隐藏的内容给拖出来。

你可以看到本案例运行后，在横向（宽度方向）并不能拖动，因为内容宽度、控件宽度是一致的，因此横向拖动并不是必要的。
