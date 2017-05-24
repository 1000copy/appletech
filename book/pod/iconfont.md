厌倦了使用位图在xcode的Assets.xcassets内，因为麻烦，包括如下的麻烦：

1. 找图
2. 图需要分尺寸
3. 需要操作员类似工作去管理

然后，现在有了字体图标，就方便多了：

1. 比较成熟的几套库，用名字就可以查
2. 矢量图，尺寸无极缩放，想要多大都行
3. 都在代码和字体文件内，不需要在工程IDE内管理

一套SwiftIcons（https://github.com/ranesr/SwiftIcons），包括了几个常见的字体图标，可以如同字体一样设置大小、背景色、前景色。下面的代码可以显示两个小飞机字体图标：


    import UIKit
    import SwiftIcons
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
        var bgImage: UIImageView!
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .blue
            var b: UIImageView!
            b = UIImageView()
            b!.frame = CGRect(x: 0,y: 0,width: 50,height: 50)
            b.image = UIImage.init(icon: .emoji(.airplane), size: CGSize(width: 35, height: 35), textColor: .white, backgroundColor: .red)
            self.view.addSubview(b!)
            var c: UIImageView!
            c = UIImageView()
            c!.frame = CGRect(x: 0,y: 50,width: 100,height: 100)
            c.image = UIImage.init(icon: .emoji(.airplane), size: CGSize(width: 35, height: 35))
            self.view.addSubview(c!)
        }
    }
当然，既然是一个库，使用Pod管理它会很方便。Podfile文件为：

    target 'three' do
      use_frameworks!
      pod 'SwiftIcons', '~> 1.4.1'
    end

这里的three，是因为我的工程名为three，你的会不一样。设置好了Podfile，就需要更新它：

    pod install --verbose --no-repo-update  

如果你是刚刚下载的cocoa pod specs那么已经加上--no-repo-update参数，这样会很快。

然后打开workspace（注意不是xcproject)

    open three.xcworkspace
因为xcworkspace包括了app和pod.xcproject，两个一起编译通过后，在单独打开：

    open three.xcproject
    
进入正常的开发过程即可。国内为了快速的下载cocoa specs，可以手工自己做，使用镜像，手动下载，初始化完成后执行一次

    git clone https://git.coding.net/CocoaPods/Specs.git ~/.cocoapods/repos/master
    pod repo update

使用pod install就得慢死。


常见字体，比如http://fontawesome.io/icons/，查找还是很方便的。

