使用SnapKit布局当然不错，但是我觉得Cartography更好，因为可以写出更加规整的布局代码。表达式总是比起链式函数容易阅读。

依然是布局三个Label，我把两种都写出来做一个对比：

    import SnapKit
    import UIKit
    import Cartography
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        var window: UIWindow?
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let page = Page()
            self.window!.rootViewController = page
            self.window?.makeKeyAndVisible()
            return true
        }
    }
    class Page: UIViewController {
        var count = 0
        var label1 : UILabel!
        var label2 : UILabel!
        var label3 : UILabel!
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = .white
            label1   = UILabel()
            label1.backgroundColor = .red
            view.addSubview(label1)
            
            label2   = UILabel()
            label2.backgroundColor = .red
            view.addSubview(label2)
            
            label3   = UILabel()
            label3.backgroundColor = .red
            view.addSubview(label3)
            
            label1.text = "1111"
            label2.text = "2222"
            label3.text = "3333"
            setup_cartography()
        }
        func setup_cartography(){
            constrain(view,label1,label2,label3){
                $1.left == $0.left  + 5
                $1.top  == $0.top + 100
                //
                $2.left == $1.right + 10
                $2.top  == $1.top
                //
                $3.left == $1.left
                $3.top  == $1.bottom + 5
            }
        }
        func setup_snapx(){
            label1.snp.makeConstraints{
                $0.left.equalTo(view).offset(5);
                $0.top.equalTo(view).offset(100);
            }
            label2.snp.makeConstraints{
                $0.left.equalTo(label1.snp.right).offset(10);
                $0.top.equalTo(label1)
            }
            label3.snp.makeConstraints{
                $0.left.equalTo(label1)
                $0.top.equalTo(label1.snp.bottom).offset(5)
            }
        }
    }

Cartography内声明布局的表达式中，使用到了“==”操作符，它并不是拿来做等值判断的，而是声明两者恒等，是一个运算符的重载。运算符的重载用在这里，真是很帅气。学到了。