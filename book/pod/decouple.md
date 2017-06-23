我们常常会需要把多个类耦合在一起以便共同完成一个或者一组功能。但是同时也意味着其中单独的类因为依赖了其他的类，当被转移到其中工程中就会无法无法编译通过，更加谈不上运行了。比如如下的案例的几个类就是完全的胶合在一起：

     import UIKit
     @UIApplicationMain
     class AppDelegate: UIResponder, UIApplicationDelegate {
        var window: UIWindow?
        var nav : Nav?
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            nav = Nav()
            self.window!.rootViewController = nav
            self.window?.makeKeyAndVisible()
            return true
        }
     }
     class Nav: UINavigationController {
        var count = 0
        var label : UILabel!
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = .white
            self.pushViewController(Level1(), animated: true)
        }
     }
     class Level1: UIViewController {
        var count = 0
        var label : UILabel!
        override func viewDidLoad() {
            super.viewDidLoad()
            self.title = "Level 1"
            self.view.backgroundColor = .white
            view.addSubview(DiveButton("Dive Into 2",rect,buttonAction))
        }
        func buttonAction(){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.nav?.pushViewController(Level2(), animated: true)
        }
     }
     class Level2: UIViewController {
        var count = 0
        var label : UILabel!
        override func viewDidLoad() {
            super.viewDidLoad()
            self.title = "Level 2"
            self.view.backgroundColor = .white
            view.addSubview(DiveButton("Dive Into 3",rect,buttonAction))
        }
        func buttonAction(){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.nav?.pushViewController(Level3(), animated: true)
        }
     }
     class Level3: UIViewController {
        var count = 0
        var label : UILabel!
        override func viewDidLoad() {
            super.viewDidLoad()
            self.title = "Level 3"
            self.view.backgroundColor = .white
            view.addSubview(DiveButton("END",rect,buttonAction))
        }
        func buttonAction(){}
     }
    let rect = CGRect(x: 120, y: 100, width: 100, height: 50)
    class DiveButton : UIButton{
        var onClick : (()->Void)?
        init(_ title : String ,_ rect : CGRect,_ onClick :@escaping ()->Void){
            super.init(frame: rect)
            self.setTitle(title,for: .normal)
            addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            self.backgroundColor = .red
            self.onClick = onClick
            
        }
        func buttonAction(_ sender:UIButton!){
            if onClick != nil {
                onClick!()
            }
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

其中的Level1依赖于AppDelegate和Level2。等等。当我们看上了Level1在某个新项目中的重用时，会因为它引用了AppDelegate和Level2，而无法单独完整的移动到新项目中并且保持可以编译通过的状态。

发现存在多个类之间需要耦合的代码时，可以使用消息机制来剿除这样的耦合。在此案例中，具体而言，就是说当Level1需要在点击按钮执行任务时，不再直接引用并创建Level2的实例，而是发送一个消息，消息的接收处去真正创建这个页面。消息的特点是，可以在任何一个类中被接收，因为这样的耦合关系可以变得非常灵活。如下代码中，将会在AppDelegate类中声明接受此消息，并处理此消息，具体做法如下：

    import UIKit
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        var window: UIWindow?
        var nav : Nav?
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
             NotificationCenter.default.addObserver(self, selector: #selector(dive2), name: Notification.Name("dive2"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(dive3), name: Notification.Name("dive3"), object: nil)
            self.window = UIWindow(frame: UIScreen.main.bounds)
            nav = Nav()
            self.window!.rootViewController = nav
            self.window?.makeKeyAndVisible()
            return true
        }
        func dive2(){
            nav?.pushViewController(Level2(), animated: true)
        }
        func dive3(){
            nav?.pushViewController(Level3(), animated: true)
        }
    }
    class Nav: UINavigationController {
        var count = 0
        var label : UILabel!
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = .white
            self.pushViewController(Level1(), animated: true)
        }
    }
    class Level1: UIViewController {
        var count = 0
        var label : UILabel!
        override func viewDidLoad() {
            super.viewDidLoad()
            self.title = "Level 1"
            self.view.backgroundColor = .white
            view.addSubview(DiveButton("Dive 2",rect,click))
        }
        func click(){
            NotificationCenter.default.post(name: Notification.Name("dive2"), object: nil)
        }
    }
    class Level2: UIViewController {
        var count = 0
        var label : UILabel!
        override func viewDidLoad() {
            super.viewDidLoad()
            self.title = "Level 2"
            self.view.backgroundColor = .white
            view.addSubview(DiveButton("Dive 3",rect,click))
        }
        func click(){
            NotificationCenter.default.post(name: Notification.Name("dive3"), object: nil)
        }
    }
    class Level3: UIViewController {
        var count = 0
        var label : UILabel!
        override func viewDidLoad() {
            super.viewDidLoad()
            self.title = "Level 3"
            self.view.backgroundColor = .white
            view.addSubview(DiveButton("Dive End",rect,click))
        }
        func click(){}
    }
    let rect = CGRect(x: 120, y: 100, width: 100, height: 50)
    class DiveButton : UIButton{
        var onClick : (()->Void)?
        init(_ title : String ,_ rect : CGRect,_ onClick :@escaping ()->Void){
            super.init(frame: rect)
            self.setTitle(title,for: .normal)
            addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            self.backgroundColor = .red
            self.onClick = onClick
            
        }
        func buttonAction(_ sender:UIButton!){
            if onClick != nil {
                onClick!()
            }
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
这样就可以把本来是网状的类关系，变成以AppDelegate为中心的星型关系，从而让每个Level类可以解除耦合，任何移动到新的工程内而可以保持编译通过，重用它的本身的功能。

