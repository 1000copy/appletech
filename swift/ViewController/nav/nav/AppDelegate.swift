import UIKit

class Level1: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Level 1"
        let btn = UIButton()
        btn.frame = CGRect(x: 10,y: 100,width: 100,height: 100)
        btn.setTitle("Push", for: UIControlState())
        btn.addTarget(self, action: #selector(Level1.drill(_:)), for: .touchDown)
        self.view.addSubview(btn)
    }
    func drill(_ sender: UIButton!){
        self.navigationController!.pushViewController(Level2(), animated: true)
    }
}

class Level2: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Level 2"
        let btn = UIButton()
        btn.frame = CGRect(x: 10,y: 100,width: 100,height: 100)
        btn.setTitle("Pop", for: UIControlState())
        self.view.addSubview(btn)
        btn.addTarget(self, action: #selector(Level2.pop(_:)), for: .touchDown)
    }
    func pop(_ sender: UIButton!){
        self.navigationController!.popViewController(animated: true)
    }
}


class Nav : UINavigationController{
    override func viewDidLoad() {
        super.viewDidLoad()
        let  p = Level1()
        viewControllers = [p]
    }
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    static var Delegate:AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    var nav :Nav?
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        nav = Nav()
        self.window!.rootViewController = nav
        self.window?.makeKeyAndVisible()
        return true
    }
}

//        navigationController!.navigationItem.rightBarButtonItem = editButtonItem()
//        navigationItem.rightBarButtonItem = editButtonItem()
//        let item = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "doAdd:")
//        navigationItem.leftBarButtonItem = item

