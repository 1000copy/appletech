iOS的模糊化，会让界面很炫酷，用了不能停。本案例使用了FXBlurView，对图片进行模糊处理。

使用Pod文件：

    target 'five' do
      use_frameworks!
      pod 'FXBlurView', '~> 1.6.4'
    end
然后执行pod install：

    pod install --verbose --no-repo-update
    
如下代码可以直接编译运行：

    import UIKit
    import FXBlurView
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
        var backgroundImageView:UIImageView?
        var frostedView = FXBlurView()
        override func viewDidLoad() {
            super.viewDidLoad()
            self.backgroundImageView = UIImageView()
            self.backgroundImageView!.frame = self.view.frame
            self.backgroundImageView!.contentMode = .scaleToFill
            view.addSubview(self.backgroundImageView!)
            frostedView.underlyingView = self.backgroundImageView!
            frostedView.isDynamic = true
            frostedView.tintColor = UIColor.black
            frostedView.frame = self.view.frame
            self.view.addSubview(frostedView)
            self.backgroundImageView?.image = UIImage(named: "1.jpg")
            self.frostedView.updateAsynchronously(true, completion: nil)
        }
    }
这是我使用的图（文件名为1.jpg）记得拖放到你的工程内：


![](https://dn-mhke0kuv.qbox.me/a44571963b630dd7ed57.jpg)