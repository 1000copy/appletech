根据Cell内的内容，动态调整Cell高度，是常用的技术。在iOS 8 或者以上的版本内，这个技术不再需要自己计算行高，而是变得简单无比。

如下案例，假设一个Cell内有两个Label，其中一个单行，第二个多行，根据第二个Label的内容的不同，高度也会不同，这个高度的变大，会导致Cell跟着变高。

具体代码如下：

    import UIKit
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        var window: UIWindow?
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            // Override point for customization after application launch.
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.makeKeyAndVisible()
            window?.rootViewController = Page()
            return true
        }
    }
    class Data: NSObject {
        class func bookList() -> [Book] {
            let bookList = [
                Book(name: "1", details: "Short Text Short Text"),
                Book(name: "2", details: "Long Text Long Text Long Text Long Text Long Text Long Text Long Text Long Text Long Text "),
                ]
            return bookList
        }
    }
    class Page: UIViewController {
        fileprivate let reuserId = "BookTableViewCellIdentifier"
        fileprivate let bookList = Data.bookList()
        fileprivate let tableview = UITableView()
        override func viewDidLoad() {
            super.viewDidLoad()
            title = "Books"
            configureTableView()
        }
        func configureTableView() {
            tableview.dataSource = self
            // key code 1 
            tableview.estimatedRowHeight = 100
            // key code 2
            tableview.rowHeight = UITableViewAutomaticDimension
            tableview.register(Cell.self, forCellReuseIdentifier: reuserId)
            view.addSubview(tableview)
            tableview.frame = self.view.frame
        }
    }
    extension Page : UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return bookList.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableview.dequeueReusableCell(withIdentifier: reuserId, for: indexPath) as! Cell
            let book = bookList[(indexPath as NSIndexPath).row]
            cell.nameLabel.text = book.name
            cell.detailLabel.text = book.details
            return cell
        }
    }
    class Cell: UITableViewCell {
        let nameLabel = UILabel()
        let detailLabel = UILabel()
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            contentView.addSubview(nameLabel)
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.numberOfLines = 0
            // key code 3
            detailLabel.numberOfLines = 0
            detailLabel.textColor = UIColor.lightGray
            contentView.addSubview(detailLabel)
            detailLabel.translatesAutoresizingMaskIntoConstraints = false
            let view1 = detailLabel
            let view2 = nameLabel
            let views = ["view1":view1,"view2":view2]
            let hConstraint1=NSLayoutConstraint.constraints(withVisualFormat: "H:|-[view1]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
            self.contentView.addConstraints(hConstraint1)
            let hConstraint2=NSLayoutConstraint.constraints(withVisualFormat: "H:|-[view2]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
            self.contentView.addConstraints(hConstraint2)
            let vConstraint=NSLayoutConstraint.constraints(withVisualFormat: "V:|-[view2]-5-[view1]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
            self.contentView.addConstraints(vConstraint)
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    class Book: NSObject {
        let name: String
        let details: String
        init(name: String, details: String) {
            self.name = name
            self.details = details
        }
    }

此代码中，关键点有三个，分别标注在代码体内。

1. 设置估计行高和行高设置为UITableViewAutomaticDimension。此代码设置后，动态调整能力就会起作用。尽管名字和功能并不那么相符，但是确实就需要设置它才可以

    tableview.estimatedRowHeight = 100
    tableview.rowHeight = UITableViewAutomaticDimension
2. 设置第二个Label可以多行

    detailLabel.numberOfLines = 0

    这样，多余一行的内容才会扩展到下一行。这个高度的增加才能撑大Cell

