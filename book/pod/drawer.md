可以使用DrawerController框架实现抽屉的效果。看起来还是蛮帅气的。

需要做的就是一个DrawerController，3个ViewController。3个ViewController分别用于左侧的抽屉，当前的抽屉，右侧的抽屉。DrawerController用来管理所有的抽屉。然后就可以通过手势左滑、右滑拉出和推入抽屉界面了。首先使用Pod引入此框架：

    target 'four' do
      use_frameworks!
      pod 'DrawerController', '~> 3.2'
    end

记得去执行下安装：

    pod install --verbose --no-repo-update
    
如下代码可以直接执行：
    
    import UIKit
    import DrawerController

    var drawerController : DrawerPage?

    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        var window : UIWindow?
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            window = UIWindow()
            drawerController = DrawerPage()
            window!.rootViewController = drawerController
            window!.rootViewController!.view.backgroundColor = .blue
            window!.makeKeyAndVisible()
            return true
        }
    }
    class DrawerPage : DrawerBase{
        init(){
            super.init(CenterPage(),LeftPage(),RightPage())
        }
        // 哄编译器开心的代码
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    }
    class DrawerBase : DrawerController{
        init(_ center : UIViewController,_ left : UIViewController,_ right : UIViewController){
            super.init(centerViewController: center, leftDrawerViewController: left, rightDrawerViewController: right)
            openDrawerGestureModeMask=OpenDrawerGestureMode.panningCenterView
            closeDrawerGestureModeMask=CloseDrawerGestureMode.all;
        }
        // 从入门到入门： 
        // 1. What exactly is init coder aDecoder?
        // 2. What does the question mark means in public init?(coder aDecoder: NSCoder)?
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    class LeftPage: UIViewController {
        var count = 0
        var label : UILabel!
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = .white
            label   = UILabel()
            label.frame = CGRect(x: 100, y: 100, width: 120, height: 50)
            label.text =  "Left"
            view.addSubview(label)
            let button   = UIButton(type: .system)
            button.frame = CGRect(x: 120, y: 150, width: 120, height: 50)
            button.setTitle("Close",for: .normal)
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            view.addSubview(button)
        }
        func buttonAction(_ sender:UIButton!){
            drawerController?.toggleLeftDrawerSide(animated: true, completion: nil)
        }
    }
    class RightPage: UIViewController {
        var count = 0
        var label : UILabel!
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = .white
            label   = UILabel()
            label.frame = CGRect(x: 100, y: 100, width: 120, height: 50)
            label.text =  "Right"
            view.addSubview(label)
            let button   = UIButton(type: .system)
            button.frame = CGRect(x: 120, y: 150, width: 120, height: 50)
            button.setTitle("Close",for: .normal)
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            view.addSubview(button)
        }
        func buttonAction(_ sender:UIButton!){
            drawerController?.toggleRightDrawerSide(animated: true, completion: nil)
        }
    }
    class CenterPage: UIViewController {
        var label : UILabel!
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = .white
            label   = UILabel()
            label.frame = CGRect(x: 100, y: 100, width: 120, height: 50)
            label.text =  "Center"
            view.addSubview(label)
            let button   = UIButton(type: .system)
            button.frame = CGRect(x: 120, y: 150, width: 120, height: 50)
            button.backgroundColor = .blue
            button.setTitle("Left Page Drawer",for: .normal)
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            view.addSubview(button)
            let button1   = UIButton(type: .system)
            button1.frame = CGRect(x: 120, y: 200, width: 220, height: 50)
            button1.contentHorizontalAlignment = .left
            button1.setTitle("Right Page Drawer",for: .normal)
            button1.addTarget(self, action: #selector(buttonAction1(_:)), for: .touchUpInside)
            button1.backgroundColor = .red
            view.addSubview(button1)
        }
        func buttonAction(_ sender:UIButton!){
            drawerController?.toggleLeftDrawerSide(animated: true, completion: nil)
        }
        func buttonAction1(_ sender:UIButton!){
            drawerController?.toggleRightDrawerSide(animated: true, completion: nil)
        }
    }

代码执行起来后，可以看到首页标签显示为Center，还有两个按钮，分别为Left Page Drawer ,Right Page Drawer。点击即可拉出左侧或者右侧的抽屉（一个ViewController）。也可以使用手势拉出和推入抽屉。




