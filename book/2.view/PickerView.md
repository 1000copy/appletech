
## PickerView

UIPickerView提供了类似机械密码锁一样风格的控件。它可以提供一组或者多组值的显示和选择。

如下代码展示了此控件的能力：

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
    // picker view
    class Page: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
        var p: UIPickerView!
        let values = [["1", "2", "3"],["one", "two", "three"]]
        func numberOfComponents(in pickerView: UIPickerView) -> Int{
            return 2
        }
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
            return values[component].count
        }
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return values[component][row]
        }
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
            print(values[component][row])
        }
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            return 100
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = UIColor.white
            // 这个frame太小的话，会看不到文字，以至于误以为代码错误。
            p = UIPickerView()
            p.frame =  CGRect(x: 10,y: 50,width: 320,height: 200)
            p.dataSource = self
            p.delegate = self
            view.addSubview(p)
        }
    }

本案例提供了2组数据集合供控件用来显示内容和做出选择。

为了提供数据给控件，需要实现UIPickerViewDataSource协议；为了监听事件，需要实现UIPickerViewDelegate协议。



