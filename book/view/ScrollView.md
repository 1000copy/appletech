UIScrollView支持显示尺寸比控件更大的内容。允许用户通过手势来滑动、放大缩小内容。

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
你可以运行后，拖动查看本来因为控件比内容小而不得不隐藏的内容。

这里的控件高度是100，内容是三个高度为100的、从上到下排列的标签，总高度为300。这三个标签都是UIScrollView的内容，但是总高度比UIScrollView高，因此UIScrollView允许用户通过手势比如滑动去查看更多的被隐藏的内容。你可以看到本案例运行后，在横向（宽度方向）并不能拖动，因为内容宽度、控件宽度是一致的，因此并不必要。