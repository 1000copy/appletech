对TableView，下拉刷新新的数据是很方便的。iOS内置有一个下拉刷新控件UIRefreshControl，虽然不能做上拉刷新，但是因为使用简单，倒也值得介绍。

如下代码，使用TableView加载OS列表，每次下拉，都模拟刷新一条新的OS项目：

    import UIKit
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        var window: UIWindow?
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let page = Page()
            page.view.backgroundColor = .blue
            self.window!.rootViewController = page
            self.window?.makeKeyAndVisible()
            return true
        }
    }
    class Page: UIViewController {
        var a : Table!
        override func viewDidLoad() {
            super.viewDidLoad()
            a  = Table()
            a.frame = self.view.frame
            self.view.addSubview(a)
            refreshControl = UIRefreshControl()
            refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
            refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
            a.addSubview(refreshControl)
        }
        var refreshControl: UIRefreshControl!
        var index = 0
        let oses = ["1","2","3","4",]
        func refresh(sender:AnyObject) {
            if index < oses.count  {
                a.os.insert("os - " + oses[index], at: 0)
                a.reloadData()
                index += 1
            }
            refreshControl.endRefreshing()
        }
    }
    class Table : UITableView,UITableViewDataSource,UITableViewDelegate{
        var os = ["Windows","OS X","Linux"]
        override init(frame: CGRect, style: UITableViewStyle) {
            super.init(frame:frame,style:style)
            self.dataSource = self
            self.delegate = self
        }
        required init?(coder aDecoder: NSCoder) {
            super.init(coder:aDecoder)
        }
        func numberOfSections(in: UITableView) -> Int {
            return 1
        }
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 44
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return os.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let arr = os
            let a = UITableViewCell(style: .default, reuseIdentifier: nil)
            a.textLabel?.text = String(describing:arr[indexPath.row])
            return a
        }
    }

其他的内容，和正常的TableView加载数据类似。不同的就是，这里创建了一个UIRefreshControl的实例，并添加一个.valueChanged的目标到函数refresh，这样每次下拉，都会触发一次此函数，在这个函数里面，会对TableView的数据源做插入，并重新加载TableView。

执行起来，试试下拉，可以看到效果。