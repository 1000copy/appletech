TableViewCell提供了种种定制的可能，包括textLabel，detailLabel，各种访问附件等。但是需要死记硬背，何必呢，反正一个继承了UITableViewCell的子类，然后在其内加入自己的定制View其实并不复杂，并且使用了同样的加入subView的方案。因此，我常常更加倾向于使用这样的类。因为更加通用，并且更加灵活，因为，你想要的任何视图和它们自己组合的布局，都是可以自由定义的。

如下案例，就是一个使用继承子类方案的TableView：

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
    class Table: UITableView,UITableViewDataSource{
        let arr = ["Long text Long text \nLong text Long text Long text Long text Long text Long text Long text ","delphi"]
        let MyIdentifier = "cell"
        override init(frame: CGRect, style: UITableViewStyle) {
            super.init(frame:frame,style:style)
            self.dataSource = self
            self.register(Cell.self, forCellReuseIdentifier: MyIdentifier)
        }
        required init?(coder aDecoder: NSCoder) {
            super.init(coder:aDecoder)
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arr.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let a = tableView.dequeueReusableCell(withIdentifier: MyIdentifier) as! Cell
            a.view1.text = String(arr[indexPath.row])
            return a
        }
    }
    class Cell : UITableViewCell{
        var view1  = UILabel()
        override func layoutSubviews() {
            self.contentView.addSubview(view1)
            self.contentView.translatesAutoresizingMaskIntoConstraints = false
            view1.translatesAutoresizingMaskIntoConstraints = false
            let views = ["view1":view1]
            let hConstraint=NSLayoutConstraint.constraints(withVisualFormat: "H:|-[view1]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
            self.contentView.addConstraints(hConstraint)
            let vConstraint=NSLayoutConstraint.constraints(withVisualFormat: "V:|-[view1]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
            self.contentView.addConstraints(vConstraint)
        }
    }
    class Page: UIViewController {
        var a : Table!
        override func viewDidLoad() {
            super.viewDidLoad()
            a  = Table()
            a.frame = CGRect(x: 0,y: 30,width: 300,height: 400)
            self.view.addSubview(a)
            a.estimatedRowHeight = 44.0
            a.rowHeight = UITableViewAutomaticDimension
        }
    }