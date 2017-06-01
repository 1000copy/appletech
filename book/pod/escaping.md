使用闭包，有两种情况，一种是在调用者完成前闭包就被执行完成了。还有一种则相反：调用函数完成了，但是闭包还没有被调用或者没有被完成。后者被称为逃逸闭包。

所有网络请求的函数，在完成调用请求后，直到响应返回，闭包才会被调用，所以这个类型的网络请求函数内等待响应的闭包就是逃逸闭包。这个类型的闭包，需要程序员手工加入一个@escapings标记才可以编译通过。

如下代码，展示了一个非逃逸闭包，和一个逃逸闭包。后者已经被标记了@escapings：

    class AppDelegate: UIResponder, UIApplicationDelegate {
        var window : UIWindow?
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            func syncRequest(callBack: ()->Void ) {
                callBack()
            }
            func asyncRequest( callBack: @escaping()->Void ) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    callBack()
                })
            }
            syncRequest(){
                print("callback")
            }
            asyncRequest(){
                print("delay 1s callback")
            }
            window = UIWindow()
            window!.rootViewController = UIViewController()
            window!.rootViewController!.view.backgroundColor = .blue
            window!.makeKeyAndVisible()
            return true
        }
    }

函数DispatchQueue.main.asyncAfter用来延时。此处延时1s再调用callback，演示了一个逃逸闭包的效果。

闭包可能需要引用当前上下文的变量，因此当调用者完成后，如果标记了逃逸闭包，那么当前调用的上下文依然会保持。如果在该标记的地方没有标记的话，会怎么样？不会在运行时报错，而是在编译期间就报错了。

因为编译器知道你没有立即调用callback。好智能。

