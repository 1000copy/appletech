import UIKit

class Level1: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Level 1"
        let btn = UIButton()
        btn.frame = CGRectMake(10,100,100,100)
        btn.setTitle("Push", forState: .Normal)
        btn.addTarget(self, action: "drill:", forControlEvents: .TouchDown)
        self.view.addSubview(btn)
    }
    func drill(sender: UIButton!){
        self.navigationController!.pushViewController(Level2(), animated: true)
    }
}

class Level2: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Level 2"
        let btn = UIButton()
        btn.frame = CGRectMake(10,100,100,100)
        btn.setTitle("Pop", forState: .Normal)
        self.view.addSubview(btn)
        btn.addTarget(self, action: "pop:", forControlEvents: .TouchDown)
    }
    func pop(sender: UIButton!){
        self.navigationController!.popViewControllerAnimated(true)
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
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    var nav :Nav?
    var window: UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
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

