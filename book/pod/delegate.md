在解决一个遗产代码的过程中，我希望对UIAlertView稍作封装，以便从巨大的ViewController内分离出特定的AlertView的代码，我这样做的：

    import UIKit
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        var window : UIWindow?
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            window = UIWindow()
            window!.rootViewController = UIViewController()
            window!.rootViewController!.view.backgroundColor = .blue
            window!.makeKeyAndVisible()
            let a = AlertView()
            a.show()
            return true
        }
    }
    class AlertView : UIViewController,UIAlertViewDelegate{
        var done : ((_ buttonIndex: Int)->Void)?
        func show(){
            var createAccountErrorAlert: UIAlertView = UIAlertView()
            createAccountErrorAlert.delegate = self
            createAccountErrorAlert.title = "Oops"
            createAccountErrorAlert.message = "Could not create account!"
            createAccountErrorAlert.addButton(withTitle: "Dismiss")
            createAccountErrorAlert.addButton(withTitle: "Retry")
            createAccountErrorAlert.show()
        }
        func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int){
                print("Why delegate of alert view does not work?")
        }
    }
出乎意料的是，点击按钮的时候，alertView:clickedButtonAt:就是不执行。然后很快问题解决，原因在于，AlertView实例是局部的，代码执行后实例已经被释放，委托也就跟着没了。

解决方法很简单，把：
    
    let a = AlertView()
    
改成

        var a : AlertView
        ...
        a = AlertView()
即可。
