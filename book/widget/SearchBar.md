UISearchBar实现了一个用于填写文本以便搜索的控件。它由一个文本框、一个搜索按钮、一个书签按钮、一个取消按钮构成。它并不执行真正的搜索，而是通过实现UISearchBarDelegate协议，在协议函数内执行真正的搜索。

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
        class Page: UIViewController,UISearchBarDelegate{
            var c : UISearchBar!
            override func viewDidLoad() {
                super.viewDidLoad()
                c = UISearchBar()
                c.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
                view.addSubview(c)
                c.delegate = self
            }
            func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
                print ("search : \(searchBar.text)")
            }
        }
默认情况下，只是显示搜索按钮。如果想要显示书签按钮和取消按钮，需要这样

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
        class Page: UIViewController,UISearchBarDelegate{
            var c : UISearchBar!
            override func viewDidLoad() {
                super.viewDidLoad()
                c = UISearchBar()
                c.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
                view.addSubview(c)
                c.delegate = self
                c.showsCancelButton = true
                c.showsBookmarkButton = true 
            }
            func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
                print ("search : \(searchBar.text)")
            }
            func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
                print ("bookmark : \(searchBar.text)")
            }
            func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
                print ("cancel : \(searchBar.text)")
            }
        }
在启动后设置属性：

        c.showsCancelButton = true
        c.showsBookmarkButton = true 

相应的按钮事件处理也在UISearchBarDelegate指定的函数中，分别是：

        func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) 
和
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) 

            

