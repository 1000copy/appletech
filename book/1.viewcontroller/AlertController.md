
##AlertController

根据选择的风格的不同，UIAlertController可以用来向用户显示一个警告信息、或者是显示一个可触控的操作列表。

首先查看一个警告信息的代码：

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

执行后可以显示一个有标题和内容的警告消息，可以点击警告消息框内的按钮来执行指定的代码。UIAlertController可以通过构造函数：

         UIAlertController(title: "title", message: "message", preferredStyle:.alert)

来指定警告信息的标题、正文和样式。可以通过类似如下的代码：

           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                    print("OK")
                }))

在此警告框内创建一个可以点击的按钮，点击此按钮后要执行的代码以匿名函数的形式通过handle参数添加。

可以使用：

        UIViewController.present(_:animated:completion:) 

来显示此警告框。

设定preferredStyle为.alert创建的就是警告信息框，如果想创建操作列表框的话，那么请设定preferredStyle为.actionSheet即可。操作列表框就是一个在屏幕下方显示一个类似菜单的选择器，每个选项都可以单独触控并执行代码。实例如下：

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

操作列表框的创建方法警告信息框的创建方法是非常类似的。




