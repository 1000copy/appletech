
##AlertController

UIAlertController用来向用户显示一个警告信息。

如下代码可以运行时立刻显示一个警告信息，代码如下：

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
    class Page:UIViewController{
        override func viewDidAppear(_ animated: Bool) {
            Alert()
        }
        func Alert(){
            let alert = UIAlertController(title: "title", message: "message", preferredStyle:.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                print("OK")
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler:nil))
            self.present(alert,animated: true,completion: nil)
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = UIColor.black
        }
    }
UIAlertController可以通过：

         UIAlertController(title: "title", message: "message", preferredStyle:.alert)

指定警告信息的标题、正文和样式。可以通过类似如下的代码：

           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                    print("OK")
                }))

方法创建一个操作，此操作会以按钮形式出现在警告信息框内。点击操作按钮后要执行的代码以匿名函数的形式通过handle参数添加。

可以使用：

        present(_:animated:completion:) 

来显示它。

除了.alert指定的样式外，还有.actionSheet类型的样式，它可以在屏幕下方显示一个类似菜单的选择器，每个选项都可以单独触控并执行代码。实例如下：

    class Page:UIViewController{
        override func viewDidAppear(_ animated: Bool) {
            ActionSheet()
        }
        func ActionSheet() {
            let sheet: UIAlertController = UIAlertController(title:nil, message:nil, preferredStyle:UIAlertControllerStyle.actionSheet)
            sheet.addAction(UIAlertAction(title:"Do something 1", style:UIAlertActionStyle.default, handler:{ action in
                print ("Do something 1")
            }))
            sheet.addAction(UIAlertAction(title:"Do something 2", style:UIAlertActionStyle.default, handler:{ action in
                print ("Do something 2")
            }))
            sheet.addAction(UIAlertAction(title:"Cancel", style:UIAlertActionStyle.cancel, handler:nil))
            self.present(sheet, animated:true, completion:nil)
        }
    }

和.alert的使用方法是非常类似的。



