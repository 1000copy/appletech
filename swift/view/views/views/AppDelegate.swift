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
        class Page: UIViewController{
            var a : UIView!
            var b : UIView!
            var c : UIView!
            override func viewDidLoad() {
                super.viewDidLoad()
                a = UIView()
                a.frame = CGRect(x: 0, y: 50, width: 50, height: 50)
                view.addSubview(a)
                a.backgroundColor = .red
                b = UIView()
                b.frame = CGRect(x: 50, y: 50, width: 50, height: 50)
                view.addSubview(b)
                b.backgroundColor = .yellow
                c = UIView()
                c.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
                b.addSubview(c)
                c.backgroundColor = .blue
                let gesture = UITapGestureRecognizer(target: self, action: #selector(action(_:)))
                b.addGestureRecognizer(gesture)
            }
            func action(_ sender:UIButton!){
                c.backgroundColor = (c.backgroundColor == .green) ?  .blue :  .green
            }
        }
