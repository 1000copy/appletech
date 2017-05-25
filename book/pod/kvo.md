KVO是Key Value Observer的缩写，可以用于监视一个对象的属性值变化，然后执行一个代码块（块、函数、闭包等）。Facebook开源了一个KVO框架，KVOController。

这个案例使用KVOController，用于App主题改变通知。通过KVO监视主题的值，当设置主题变化时，通知所有的UI类的主题处理器。代码如下：


    import UIKit
    import KVOController
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
            let button   = UIButton(type: .system)
            button.frame = CGRect(x: 120, y: 150, width: 220, height: 50)
            button.contentHorizontalAlignment = .left
            button.setTitle("Peace",for: .normal)
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            view.addSubview(button)
            let button1   = UIButton(type: .system)
            button1.frame = CGRect(x: 120, y: 200, width: 220, height: 50)
            button1.contentHorizontalAlignment = .left
            button1.setTitle("Blood",for: .normal)
            button1.addTarget(self, action: #selector(buttonAction1(_:)), for: .touchUpInside)
            view.addSubview(button1)
            self.themeChangedHandler = {[weak self] (style) -> Void in
                if "Peace" == style{
                    self!.view.backgroundColor = .blue
                }
                else{
                    self!.view.backgroundColor = .red
                }
            }
        }
        func buttonAction(_ sender:UIButton!){
            ThemeColor.shared.style = "Peace"
        }
        func buttonAction1(_ sender:UIButton!){
            ThemeColor.shared.style = "Blood"
        }
    }
    class ThemeColor :NSObject  {
        dynamic var style:String
        static let shared = ThemeColor()
        fileprivate override init(){
            style = "Blood"// or Peace
            super.init()
        }
    }
    extension NSObject {
        fileprivate struct AssociatedKeys {
            static var themeChanged = "themeChanged"
        }
        public typealias ThemeChangedClosure = @convention(block) (_ style:String) -> Void
        var themeChangedHandler:ThemeChangedClosure? {
            get {
                let closureObject: AnyObject? = objc_getAssociatedObject(self, &AssociatedKeys.themeChanged) as AnyObject?
                guard closureObject != nil else{
                    return nil
                }
                let closure = unsafeBitCast(closureObject, to: ThemeChangedClosure.self)
                return closure
            }
            set{
                guard let value = newValue else{
                    return
                }
                let dealObject: AnyObject = unsafeBitCast(value, to: AnyObject.self)
                objc_setAssociatedObject(self, &AssociatedKeys.themeChanged,dealObject,objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.kvoController.observe(ThemeColor.shared, keyPath: "style", options: [.initial,.new] , block: {[weak self] (nav, color, change) -> Void in
                    self?.themeChangedHandler?(ThemeColor.shared.style)
                    }
                )
            }
        }
    }

代码运行后，可以看到两个按钮，点击不同的按钮会切换主题。

Pod文件为：

    pod 'KVOController', '~> 1.2.0'
    
代码的效果就是，当修改：

    ThemeColor.shared.style = "Peace"

就会引发当前对象的块对象：themeChangedHandler的调用。因为使用了KVO监视了ThemeColor.shared.style，当值变化的时候，就会引发themeChangedHandler所指向的闭包的执行。闭包在set的时候被使用objc_setAssociatedObject存储于指定键（themeChanged）的值内。当运行get的时候，会使用objc_getAssociatedObject函数把它再取出来。

函数对：objc_getAssociatedObject和objc_setAssociatedObject看起来比较复杂，但是可以用于动态的为对象创建属性，因此颇为强大。

此代码不好理解，也许使用Observer设计模式来替代更好。



