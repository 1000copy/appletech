
## TableView

类UITableView是一个视图，它可以显示列表，并且列表可以分为多个分区（section）。

### 显示列表

假设一个案例：

1. 显示计算机语言清单（["java","swift","js"]和操作系统的清单 ["Windows","OS X","Linux"]
2. 这个清单在一个UITableView上做分区显示，分为两个区间，分别为Lang和OS

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

代码中Page继承于UIViewController，并且在载入时把Table作为子视图加入进来。

类Table继承于UITableView，并实现UITableViewDataSource,UITableViewDelegate，然后配合代码：

    self.dataSource = self
    self.delegate = self

就设置了UITableView的数据源对象为Table对象，指明此对象是UITableView的数据提供者。随后指定委托对象为Table对象，也就指明此对象是UITableView的外观和行为的提供者。

在此类内实现数据源协议的相关方法有：


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
            
第一个方法告诉TableView此列表共有两个区间要去显示。第二个方法告诉TableView此列表指定区间的行数，第三个方法告诉TableView指定的区间和行数的UITableViewCell对象值。

实现以下委托方法，可以定制TableView的外观：

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

协议UITableViewDataSource,UITableViewDelegate还有很多可以实现的方法，具体参考iOS的开发者官方文档。

### 添加删除修改

类UITableView不但可以显示内容，还可以实现添加删除修改数据的UI支持。接下来的代码会：

1. 用户可以看到分区显示语言和操作系统的列表
2. 用户可以查看到列表内容添加删除修改

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

对数据的增加修改删除，可以通过.reload方法传递到TableView界面上。

### 默认提供的删除和列表重排

可以自己添加按钮并执行对UITableView的列表的删除和重排。但是也可以使用它自己提供了删除和重排的UI。其中，删除流程是这样的：

1. 用户设置UITableView为编辑模式
2. 系统在当前行内容的基础上，自动加入删除按钮（内容左侧，红色的减号图标），以及重排按钮（内容右侧）
3. 用户可以选择点击删除按钮，系统向左推移内容，显示一个delete按钮
4. 用户点击delete按钮，系统就会调用程序员实现的委托对象的函数：func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: 
IndexPath)，执行真正的删除

而重排流程是这样的：

1. 用户设置UITableView为编辑模式
2. 系统在当前内容的基础上，加上删除按钮（内容左侧，红色的减号图标），以及重排按钮（内容右侧）
3. 用户可以选择按住拖动重排按钮，系统可视化这样拖动过程
4. 用户拖动完成，系统就会调用程序员实现的委托对象的函数： func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)，执行真正的重排


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
    var a : Table?
    override func viewDidLoad() {
        super.viewDidLoad()
        a  = Table()
        a!.frame = CGRect(x: 0,y: 200,width: 300,height: 200)
        self.view.addSubview(a!)
        let b = UIButton()
        b.setTitle("edit", for: UIControlState())
        b.backgroundColor = UIColor.red
        b.addTarget(self, action: #selector(edit(_:)), for: .touchDown)
        
        let e = UIButton()
        e.setTitle("Done", for: UIControlState())
        e.backgroundColor = UIColor.blue
        e.addTarget(self, action: #selector(done(_:)), for: .touchDown)
        
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
                arr.removeObject(at: indexPath.row) 
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


### TableView的装饰界面

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



### 标记

类UITableView支持对每个行做标记和取消标记。标记可以有多种，其中比较常用的是打对号图标。如下代码，演示了如何对每个行打对号标记和取消打对号标记：


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
    class Table : UITableView,UITableViewDataSource,UITableViewDelegate{
        let arr = ["java","swift","js"]
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
            a.textLabel?.text = String(arr[indexPath.row])
            return a
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
            print("did select \(indexPath.row)")
            self.deselectRow(at: indexPath, animated: false)
            if  self.cellForRow(at: indexPath)?.accessoryType !=  .checkmark{
                self.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }else{
                self.cellForRow(at: indexPath)?.accessoryType = .none
            }
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

运行起来后，可看到三个行。点击任何一个行都会在此行的行尾显示一个对号标记，再点击一次就会取消此标记。查询UITableViewCellAccessoryType的官方文档可以得到更多的标记类型。

### 优化：重用cell创建

在之前的代码中，每次调用到函数：

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell

都需要返回一个UITableViewCell实例。我们都是临时创建此实例并返回的。如果创建的UITableViewCell实例比较多时，可以通过重用已经创建的UITableViewCell实例来提高效率。做法就是：

1. 注册一个UITableViewCell类，指定它的重用标识符
2. 通过重用标识符来获取一个实例

UIKit会在内部对此实例的创建和获取过程优化。使用此优化方案的实例代码如下：

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
        let arr = ["javascript","delphi"]
        let MyIdentifier = "cell"
        override init(frame: CGRect, style: UITableViewStyle) {
            super.init(frame:frame,style:style)
            self.dataSource = self
            self.register(UITableViewCell.self, forCellReuseIdentifier: MyIdentifier)
        }
        required init?(coder aDecoder: NSCoder) {
            super.init(coder:aDecoder)
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arr.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let a = tableView.dequeueReusableCell(withIdentifier: MyIdentifier)!
            a.textLabel?.text = String(arr[indexPath.row])
            return a
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

###复合的Cell

之前的实例代码中创建的Cell的内容都是简单文字，但是实际上每个Cell都可以作为一个视图容器，装入更多的视图。如下代码展示了一个复合的Cell的创建：

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
            let arr = ["java","swift","js"]
            override init(frame: CGRect, style: UITableViewStyle) {
                super.init(frame:frame,style:style)
                self.dataSource = self
            }
            required init?(coder aDecoder: NSCoder) {
                super.init(coder:aDecoder)
            }
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return arr.count
            }
            
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let a = UITableViewCell(style: .default, reuseIdentifier: nil)
                a.textLabel?.text = String(arr[indexPath.row])
                let s = UISwitch()
                s.frame = CGRect(x: 0,y: 0,width: 20,height: 20)
                s.addTarget(self, action: #selector(Table.action(_:)), for: .valueChanged)
                s.isOn = true
                a.accessoryView = s
                return a
            }
            func action(_ sender : UISwitch!){
                print(sender.isOn)
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

本案例在每个Cell中添加了一个UISwitch按钮，并且可以如同一般的UIView一样的响应此按钮的事件。


### 默认的Cell风格

可以不必自己定制Cell样式，而是直接使用系统提供的。你可以通过为
1. .style属性
2. textLabel属性
3. detailTextLabel属性
4. .imageView属性
5. .accessoryType属性

而让Cell外观变得丰富多彩：

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
            a.frame = CGRect(x: 0,y: 30,width: 300,height: 400)
            self.view.addSubview(a)
        }
    }


    class Row {
        var text : String = ""
        var text2 : String = ""
        var image : UIImage
        var access : UITableViewCellAccessoryType
        var style :  UITableViewCellStyle
        init( text : String ,text2:String ,image:UIImage,access:UITableViewCellAccessoryType,style :  UITableViewCellStyle){
            self.text = text
            self.text2 = text2
            self.image = image
            self.access = access
            self.style = style
        }
    }
    class Table: UITableView,UITableViewDataSource{
        let arr = [
            Row(
                text:"java",
                text2:"old plain",
                image:UIImage.imageWithColor(UIColor.red),
                access:UITableViewCellAccessoryType.checkmark,
                style: UITableViewCellStyle.value1),
            Row(
                text:"ruby",
                text2:"new cool slow",
                image:UIImage.imageWithColor(UIColor.green),
                access:UITableViewCellAccessoryType.detailButton,
                style: UITableViewCellStyle.value2),
            Row(
                text:"swift",
                text2:"new cool quick ",
                image:UIImage.imageWithColor(UIColor.blue),
                access:UITableViewCellAccessoryType.detailDisclosureButton,
                style: UITableViewCellStyle.subtitle)
        ]
        override init(frame: CGRect, style: UITableViewStyle) {
            super.init(frame:frame,style:style)
            self.dataSource = self
            
        }
        required init?(coder aDecoder: NSCoder) {
            super.init(coder:aDecoder)
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arr.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let a = UITableViewCell(style: arr[indexPath.row].style, reuseIdentifier: nil)
            a.textLabel?.text = arr[indexPath.row].text
            a.detailTextLabel?.text = arr[indexPath.row].text2
            a.imageView?.image = arr[indexPath.row].image
            a.accessoryType = arr[indexPath.row].access
            return a
        }
    }
    extension UIImage {
        class func imageWithColor(_ color: UIColor) -> UIImage {
            let rect = CGRect(x: 0.0, y: 0.0, width: 10.0,height: 10.0 )
            UIGraphicsBeginImageContext(rect.size)
            let context = UIGraphicsGetCurrentContext()
            
            context?.setFillColor(color.cgColor)
            context?.fill(rect)
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return image!
        }
    }

你可以实际运行此代码，了解不同样式的差异。可以通过官方手册查询UITableViewCellStyle和UITableViewCellAccessoryType的不同选择。

### UITableViewController

我们一直使用UITableView来显示一个列表，也可以使用UITableViewController来完成类似的工作。比如：

    import UIKit
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        var window: UIWindow?
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let page = LangTableViewController()
            page.view.backgroundColor = .blue
            self.window!.rootViewController = page
            self.window?.makeKeyAndVisible()
            return true
        }
    }

    class LangTableViewController : UITableViewController{
        let arr = ["swift","obj-c","ruby"]
        let MyIdentifier = "cell"
        override func viewDidLoad() {
            super.viewDidLoad()
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: MyIdentifier)
        }
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arr.count
        }
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let a = tableView.dequeueReusableCell(withIdentifier: MyIdentifier)
            a!.textLabel?.text = arr[indexPath.row]
            return a!
        }
    }

使用UITableViewController的不同之处在于：

1. 不需要实现UITableViewDataSource和UITableViewDelegate的方法，而是覆盖已经在父类内实现过了的方法。
2. 会自动把UITableView填满AppDelegate.window视图内，而不必程序员指定位置和大小。


