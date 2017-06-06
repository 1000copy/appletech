iOS默认提供的布局技术强大而愚蠢。幸好有一个封装的包SnapKit，可以让布局变得容易阅读和修改。

假设要在一个UIViewController上布局两个label，要求是：
1. 第一个label的xy距离父视图为5，100
2. 第二个label 的x距离第一个label为10，高度一样
3. 第三个label的y距离第一个label底边为10，x一样

那么可以这样做：

    import SnapKit
    import UIKit
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        var window: UIWindow?
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let page = Page1()
            self.window!.rootViewController = page
            self.window?.makeKeyAndVisible()
            return true
        }
    }
    class Page1: UIViewController {
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
            setup()
        }
        func setup(){
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
        // old stupid approach
        func setup1(){
            label1.snp.makeConstraints{ (make) -> Void in
                make.left.equalTo(view).offset(5);
                make.top.equalTo(view).offset(100);
            }
            label2.snp.makeConstraints{ (make) -> Void in
                make.left.equalTo(label1.snp.right).offset(10);
                make.top.equalTo(label1)
            }
            label3.snp.makeConstraints{ (make) -> Void in
                make.left.equalTo(label1)
                make.top.equalTo(label1.snp.bottom).offset(5)
            }
        }
    }

函数setup1的默认的布局代码，setup函数的代码则利用了闭包的特性，可以不必编写参数，直接用$引用参数，这样做会让代码更加简练，是一种实用的技能。
