框架MJRefresh提供了上拉刷新或者下拉刷新，非常的喜闻乐见。

需要使用pod:

    target 'Swift-MJrefresh' do
      use_frameworks!
      # Pods for Swift-MJrefresh
      pod 'MJRefresh'
    end
记得去执行命令安装此框架：

    pod install --verbose --no-repo-update
    
如下案例，演示此框架的使用过程：


    import UIKit
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        var window : UIWindow?
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            window = UIWindow()
            window!.rootViewController = Page()
            window!.rootViewController!.view.backgroundColor = .blue
            window!.makeKeyAndVisible()
            return true
        }
    }
    import MJRefresh
    class Page: UIViewController ,UITableViewDataSource{
        var tableview: UITableView!
        let header = MJRefreshNormalHeader()
        let footer = MJRefreshAutoNormalFooter()
        override func viewDidLoad() {
            super.viewDidLoad()
            self.tableview = UITableView()
            tableview.dataSource = self
            tableview.frame = view.frame
            self.view.addSubview(tableview)
            header.setRefreshingTarget(self, refreshingAction: Selector("headerRefresh"))
            self.tableview.mj_header = header
            footer.setRefreshingTarget(self, refreshingAction: Selector("footerRefresh"))
            self.tableview.mj_footer = footer
        }
        func headerRefresh(){
            print("下拉刷新")
            self.tableview.mj_header.endRefreshing()
        }
        var index = 0
        func footerRefresh(){
            print("上拉刷新")
            self.tableview.mj_footer.endRefreshing()
            // 2次后模拟没有更多数据
            index = index + 1
            if index > 2 {
                footer.endRefreshingWithNoMoreData()
            }
        }
        func numberOfSections(in: UITableView) -> Int {
            return 1;
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 10;
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "a")
            cell.textLabel!.text = "测试刷新"
            return cell
        }
        func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
            return 150;
        }
    }
实验发现，即使是Obj-c写的框架，也只要：

    import MJRefresh
    
而不再需要桥接文件（bridge.h)。以前都是需要的，为什么不需要了？还需要进一步查明。

