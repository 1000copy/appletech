类UITableView表示一个列表视图，此视图可以显示列表，并且列表可以分为多个区间（section）。

##显示列表

假设一个案例：

1. 显示计算机语言清单（["java","swift","js"]和操作系统的清单 ["Windows","OS X","Linux"]
2. 这个清单在一个UITableView上做分区显示，分为两个区间

那么代码如下：

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
                a.frame = CGRect(x: 0,y: 50,width: 300,height: 500)
                self.view.addSubview(a)
            }
        }
        
        
        class Table : UITableView,UITableViewDataSource,UITableViewDelegate{
            let sect = ["Lang","OS"]
            let lang = ["java","swift","js"]
            let os = ["Windows","OS X","Linux"]
            override init(frame: CGRect, style: UITableViewStyle) {
                super.init(frame:frame,style:style)
                self.dataSource = self
                self.delegate = self
            }
            required init?(coder aDecoder: NSCoder) {
                super.init(coder:aDecoder)
            }
            func numberOfSections(in: UITableView) -> Int {
                return 2
            }
            func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
                let rect = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44)
                let footerView = UILabel(frame:rect)
                footerView.text = sect[section]
                return footerView
            }
            func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
                return 44
            }
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return section == 0 ?lang.count:os.count
            }
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let arr = indexPath.section == 0 ? lang:os
                let a = UITableViewCell(style: .default, reuseIdentifier: nil)
                a.textLabel?.text = String(describing:arr[indexPath.row])
                return a
            }
        }
代码创建了三个类，其中的AppDelegate和之前的并没有什么不同，Page继承于UIViewController，也和之前的代码类似，只是在载入时把Table作为子视图加入进来。要特别介绍的是Table。

Table继承于UITableView，并实现UITableViewDataSource,UITableViewDelegate，在配合代码：

           self.dataSource = self
           self.delegate = self

就指明了UITableView的数据源对象为Table，委托对象也是Table。前者指明此对象是UITableView的数据提供者，后者指明此对象是UITableView的外观和行为的提供者。

具体数据提供的方法就是在此类内实现方法：


            func numberOfSections(in: UITableView) -> Int {
                return 2
            }
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return section == 0 ?lang.count:os.count
            }
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let arr = indexPath.section == 0 ? lang:os
                let a = UITableViewCell(style: .default, reuseIdentifier: nil)
                a.textLabel?.text = String(describing:arr[indexPath.row])
                return a
            }
            
第一个方法告诉TableView此列表共有两个区间要去显示。第二个方法告诉TableView此列表每个区间的行数，第三个方法告诉TableView指定的区间和行数的内容是什么。

作为UITableView的外观和行为的提供者，具体体现是实现了这些方法：

            func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
                let rect = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44)
                let footerView = UILabel(frame:rect)
                footerView.text = sect[section]
                return footerView
            }
            func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
                return 44
            }
            
第一个方法为指定的区间创建一个头视图，第二个方法指示指定区间的行高。

协议UITableViewDataSource,UITableViewDelegate还有很多可以实现的方法，具体参考iOS的开发者参考资料。

## 添加删除修改

类UITableView不但可以显示内容，还可以配合很多操作。这些内容的操作的基本流程就是修改数据源，然后通知TableView重新装入。代码入下：

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
                a.frame = CGRect(x: 0,y: 50,width: 300,height: 500)
                self.view.addSubview(a)
            }
        }
        
        
        class Table : UITableView,UITableViewDataSource,UITableViewDelegate{
            var sect = NSMutableArray.init(array: ["Lang","OS"])
            var lang = NSMutableArray.init(array: ["java","swift","js"])
            var os = NSMutableArray.init(array:["Windows","OS X","Linux"])
            var t = Timer()
            var count  = 0
            override init(frame: CGRect, style: UITableViewStyle) {
                super.init(frame:frame,style:style)
                self.dataSource = self
                self.delegate = self
                t.invalidate()
                t = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
            }
            required init?(coder aDecoder: NSCoder) {
                super.init(coder:aDecoder)
            }
            func update() {
                if count == 0 {
                    os[0] = "Win"
                    
                }else if count == 1 {
                    os.add("FreeBSD")
                }else if count == 2 {
                    lang.removeObject(at: 0)
                }
                count += 1
                if count >= 3 {
                     t.invalidate()
                }
                self.reloadData()
            }
            func numberOfSections(in: UITableView) -> Int {
                return sect.count
            }
            func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
                let rect = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44)
                let footerView = UILabel(frame:rect)
                footerView.text = String(describing: sect[section])
                return footerView
            }
            func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
                return 44
            }
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return section == 0 ?lang.count:os.count
            }
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let arr = indexPath.section == 0 ? lang  as NSArray :os  as NSArray
                let a = UITableViewCell(style: .default, reuseIdentifier: nil)
                a.textLabel?.text = String(describing:arr[indexPath.row])
                return a
            }
        }


此代码和上一节的代码相比，不同在于：

1. 之前的计算机语言数组和操作系统数据被改成了可变的数组，因为在这个代码中，我们需要修改数据来验证对UITableView的修改
2. 在Table的init函数内，创建一个Timer，它每秒激发一个定时器事件，在不同的激发次数中，分别对数据做修改、添加、删除
3. 调用reload方法，从而让UITableView重新加载数据

## 默认提供的删除和列表重排

可以自己添加按钮并执行对UITableView的列表的删除和重排。但是也可以使用它自己提供了删除和重排的UI。删除流程是这样的：

1. 用户设置UITableView为编辑模式
2. 系统在当前内容的基础上，加上删除按钮（内容左侧，红色的减号图标），以及重排按钮（内容右侧）
3. 用户可以选择点击删除按钮，系统向左推移内容，显示一个delete按钮
4. 用户点击delete按钮，系统就会调用程序员实现的委托对象的函数：func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: 
IndexPath) 

重排流程是这样的：

1. 用户设置UITableView为编辑模式
2. 系统在当前内容的基础上，加上删除按钮（内容左侧，红色的减号图标），以及重排按钮（内容右侧）
3. 用户可以选择按住拖动重排按钮，系统可视化这样拖动过程
4. 用户拖动完成，系统就会调用程序员实现的委托对象的函数： func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)


代码如下：

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
            var a : LangTableRowOper1?
            override func viewDidLoad() {
                super.viewDidLoad()
                a  = LangTableRowOper1()
                a!.frame = CGRect(x: 0,y: 200,width: 300,height: 200)
                self.view.addSubview(a!)
                let b = UIButton()
                b.setTitle("edit", for: UIControlState())
                b.backgroundColor = UIColor.red
                b.addTarget(self, action: #selector(ViewController.edit(_:)), for: .touchDown)
                
                let e = UIButton()
                e.setTitle("Done", for: UIControlState())
                e.backgroundColor = UIColor.blue
                e.addTarget(self, action: #selector(Page.done(_:)), for: .touchDown)
                
                let sv = UIStackView()
                
                sv.backgroundColor = UIColor.gray
                sv.axis = UILayoutConstraintAxis.horizontal
                sv.distribution = .equalCentering;
                sv.alignment = .center;
                sv.spacing = 10;
                sv.frame = CGRect(x: 0,y: 100,width: 300,height: 50)
                sv.addArrangedSubview(b)
                
                sv.addArrangedSubview(e)
                sv.translatesAutoresizingMaskIntoConstraints = true
                self.view.addSubview(sv)
                
            }
            func edit( _ b : UIButton!){
                a!.setEditing(true, animated: true)
            }
            func done( _ b : UIButton!){
                a!.setEditing(false, animated: true)
            }
        }


        class Table : UITableView,UITableViewDataSource,UITableViewDelegate{
            var arr = NSMutableArray.init(array: ["java","swift","js"])
            override init(frame: CGRect, style: UITableViewStyle) {
                super.init(frame:frame,style:style)
                self.dataSource = self
                self.delegate = self
                
            }
            required init?(coder aDecoder: NSCoder) {
                super.init(coder:aDecoder)
            }
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return arr.count
            }
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let a = UITableViewCell(style: .default, reuseIdentifier: nil)
                a.textLabel?.text = String(describing: arr[indexPath.row])
                return a
            }
            func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
                if editingStyle ==  .delete{
                    arr.removeObject(at: indexPath.row) // http://stackoverflow.com/questions/21870680/invalid-update-invalid-number-of-rows-in-section-0
                    self.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                }
            }
            func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
            {
                return true;
            }
            func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
                
                let s = sourceIndexPath.row
                let d = destinationIndexPath.row
                let temp = arr[s]
                arr.removeObject(at: s)
                arr.insert(temp, at: d)
            }
        }

注意，代码中：

        func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
            {
                return true;
            }
此函数需要实现，从而告诉UITableView那些行是可以拖动重排的。这里全部返还true，表示所有内容都可以重排。


## TableView的装饰界面

除了显示section和row之外，TableView可以加入表头表位，节头节尾，帮助程序员更好的组织内容。

我们现在来展示了一个有两个section，每个section有行的界面。通过代码加入了表头表尾、节头节尾。如下：

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
    class Table : UITableView,UITableViewDataSource{
        let arrs = [["Row 1","Row 2"],["Row 1"]]
        let titles  = ["Section Title 1","Section Title 2"]
        let footers  = ["Section Footer 1","Section Footer 2"]
        let tableheader = "Table Header"
        let tablefooter = "Table Footer"
        convenience init(){
            self.init(frame: CGRect.zero, style:UITableViewStyle.grouped)
        }
        override init(frame: CGRect, style: UITableViewStyle) {
            super.init(frame:frame,style:style)
            self.dataSource = self
            self.tableHeaderView = UIView()
            self.tableHeaderView!.frame = CGRect(x: 0, y: 0,width: 200,height: 20)
            let l = UILabel()
            l.text = tableheader
            l.frame = CGRect(x: 0, y: 0,width: 200,height: 20)
            self.tableHeaderView?.addSubview(l)
            
            self.tableFooterView = UIView()
            self.tableFooterView!.frame = CGRect(x: 0, y: 0,width: 200,height: 20)
            let f = UILabel()
            f.text = tablefooter
            f.frame = CGRect(x: 0, y: 0,width: 200,height: 20)
            self.tableFooterView?.addSubview(f)
        }
        required init?(coder aDecoder: NSCoder) {
            super.init(coder:aDecoder)
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arrs[section].count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
            let a = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: nil)
            a.textLabel?.text = String(arrs[indexPath.section][indexPath.row])
            return a
        }
        func numberOfSections(in tableView: UITableView) -> Int{
            return arrs.count
        }
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
            return titles[section]
        }
        
        func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?{
            return footers[section]
        }
    }

    class Page: UIViewController {
        var a : Table!
        override func viewDidLoad() {
            super.viewDidLoad()
            a  = Table()
            a.frame = CGRect(x: 0,y: 30,width: 300,height: 400)
            self.view.addSubview(a)
        }
    }

这里比较特别的是，函数

        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
            return titles[section]
        }
告诉TableView，每个指定section的头标题。
        func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?{
            return footers[section]
        }
告诉TableView，每个指定section的尾标题。



