extension可以为类添加新的方法。但是如果想要添加数据成员的话就会被阻止，比如如下代码：

    extension Foo {
        var _title: String?
        var title: String? {
            get {
                return _title
            }
            
            set {
                _title = newValue
            }
        }
    }
报错为：
    
    Extensions may not contain stored properties

就是说，通过extension无法直接为类添加数据成员。但是稍微转换下，还是可以做到的，方法就是使用一对看起来奇奇怪怪的方法：

    objc_getAssociatedObject/objc_setAssociatedObject

可执行代码如下：

    class Foo {
    }
    var key: Void?
    extension Foo {
        var Bar: String? {
            get {
                return objc_getAssociatedObject(self, &key) as? String
            }
            
            set {
                objc_setAssociatedObject(self,&key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    import UIKit
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        var window : UIWindow?
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            let a = Foo()
            a.Bar = "good wood"
            if let Bar = a.Bar {
                print("Bar: \(Bar)")
            } else {
                print("没有设置")
            }
            
            return true
        }
    }

方法组objc_getAssociatedObject/objc_setAssociatedObject提供了类的动态性，因此有一定的实用价值。
