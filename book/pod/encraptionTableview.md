UITableView功能强大，但是使用delegate设计模式的DataSource真的很不舒服。比如说：

1. 一堆冗长的函数签名
2. 只能拷贝，错一点都无法执行的，也不会提示你不对

冗长的函数签名是这样的：

    func numberOfSections(in: UITableView) -> Int 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 

是否可以给它一个DataSource对象，它自己就可以显示内容即可呢，就像这样：

   tableview.Datasource = [["java","swift","js"],["java","swift","js"]]

它应该可以

1. 自己提取发现有两个section
2. 每个section内的row的数量
3. 以及要显示到Cell的内容。

这是可能的，实际上，如下类Table封装完毕，使用的时候，就是可以达成希望的效果的，使用Table，你不必在自己编写这些函数，代码如下：

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
            a.ds = [["java","swift","js"],["java","swift","js"]]
            a.frame = CGRect(x: 0,y: 50,width: 300,height: 500)
            self.view.addSubview(a)
        }
    }
    class Table : UITableView,UITableViewDataSource,UITableViewDelegate{
        public var  ds : [[Any]]
        override init(frame: CGRect, style: UITableViewStyle) {
            ds = []
            super.init(frame:frame,style:style)
            
            self.dataSource = self
            self.delegate = self
        }
        required init?(coder aDecoder: NSCoder) {
            ds = []
            super.init(coder:aDecoder)
        }
        func numberOfSections(in: UITableView) -> Int {
            return ds.count
        }
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 44
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return ds[section].count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let arr = ds
            let a = UITableViewCell(style: .default, reuseIdentifier: nil)
            a.textLabel?.text = String(describing:arr[indexPath.section][indexPath.row])
            return a
        }
    }

这个案例有很多限制，比如数据源内的数据项，只能是String类型。如果想要一般的对象作为数据项，更加花哨的Cell作为外观，有办法吗？关键就是，让Cell的类型是参数化的，可以传递和修改的。为此，我们需要在Table内加入一个cellClass的类，它可以由使用这套封装的开发者传递进来。如下案例，已经完成了此工作，并提供了对象化的数据项作为案例：

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
            var s = DoubleString("Paris","Charles de Gaulle")
            var t = DoubleString("Rome","FCO")
            a  = Table()
            a.cellClass = DoubleStringCell.self
            a.ds = [[s,t]]
            a.load()
            a.frame = CGRect(x: 0,y: 50,width: 300,height: 500)
            self.view.addSubview(a)
        }
     }
     class DoubleString{
        var s1 : String
        var s2 : String
        init(_ s1:String,_ s2:String){
            self.s1=s1
            self.s2=s2
        }
     }
     class DoubleStringCell:Cell{
        var l1 : UILabel?=UILabel()
        var l2 : UILabel?=UILabel()
        override func layoutSubviews() {
            l1?.frame = CGRect(x: 0, y: 0,width: 200,height: 20)
            self.addSubview(l1!)
            l2?.frame = CGRect(x: 0, y: 25,width: 200,height: 20)
            self.addSubview(l2!)
        }
        override  func loadData(_ obj : Any){
            let ds = obj as! DoubleString
            l1?.text = ds.s1
            l2?.text = ds.s2
        }
     }
     class StringCell:Cell{
        override  func loadData(_ obj : Any){
            textLabel?.text = "\(obj)"
        }
     }
     // Framework Zone
     class Table: UITableView,UITableViewDataSource,UITableViewDelegate{
        var ds_ : [[Any]]?
        public var  ds : [[Any]]?{
            get{return ds_}
            set{
                ds_ = newValue
            }
        }
        var  cellClass_ : AnyClass?
        public var  cellClass : AnyClass?{
            get{return cellClass_}
            set{cellClass_ = newValue}
        }
        func load(){
            self.dataSource = self
            self.delegate = self
            register( cellClass, forCellReuseIdentifier: "\(cellClass)");
            print("\(cellClass)")
        }
        func numberOfSections(in: UITableView) -> Int {
            return ds!.count
        }
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 44
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return ds![section].count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let arr = ds!
            let a  = dequeueReusableCell(withIdentifier: "\(cellClass)", for: indexPath) ;
            loadCell(a,arr[indexPath.section][indexPath.row])
            return a
        }
        func loadCell(_ cell : UITableViewCell,_ item : Any){
            (cell as! Cell).loadData(item)
        }
    }
     
     class Cell : UITableViewCell{
        public func loadData(_ obj : Any){
            textLabel?.text = "implements yourself cell for \(obj)"
        }
     }

注意，在UITableViewCell内，没有viewDidLoad供你使用，对应的是layoutSubviews函数。继承了Cell，并且实现了loadData，就可以在loadData内自己加载任何传入进来的数据项对象，这里的数据项对象是DoubleString，内部承载了两个字符串。当然还可以是任何类型的对象，反正在自己的loadData内自己编写加载数据项对象就可以了。

当然，这段代码依然并不理想，因为loadData的实现，依然要求开发者自己覆盖基础类Cell的loadData。这样的耦合并不讨喜。最好是此处的函数也可以参数化，方法就是让开发者自己传递一个事件函数进来，需要时，框架调用用户的事件函数：


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
            var s = DoubleString("Paris","Charles de Gaulle")
            var t = DoubleString("Rome","FCO")
            a  = Table()
            a.onCellData = {(cell ,obj) in
                let ds = obj as! DoubleString
                let c = cell as! DoubleStringCell
                c.l1?.text = ds.s1
                c.l2?.text = ds.s2
            }
            a.cellClass = DoubleStringCell.self
            a.ds = [[s,t]]
            a.load()
            a.frame = CGRect(x: 0,y: 50,width: 300,height: 500)
            self.view.addSubview(a)
        }
    }
    class DoubleString{
        var s1 : String
        var s2 : String
        init(_ s1:String,_ s2:String){
            self.s1=s1
            self.s2=s2
        }
    }
    class DoubleStringCell:UITableViewCell{
        var l1 : UILabel?=UILabel()
        var l2 : UILabel?=UILabel()
        override func layoutSubviews() {
            l1?.frame = CGRect(x: 0, y: 0,width: 200,height: 20)
            self.addSubview(l1!)
            l2?.frame = CGRect(x: 0, y: 25,width: 200,height: 20)
            self.addSubview(l2!)
        }
    }
    // Framework Zone
    typealias  OnCellData = (_ cell : UITableViewCell ,_ obj : Any)->Void
    class Table: UITableView,UITableViewDataSource,UITableViewDelegate{
        var ds_ : [[Any]]?
        var onCellData_ : OnCellData?
        var onCellData : OnCellData?{
            get{return onCellData_}
            set{
                onCellData_ = newValue
            }
        }
        public var  ds : [[Any]]?{
            get{return ds_}
            set{
                ds_ = newValue
            }
        }
        var  cellClass_ : AnyClass?
        public var  cellClass : AnyClass?{
            get{return cellClass_}
            set{cellClass_ = newValue}
        }
        func load(){
            self.dataSource = self
            self.delegate = self
            register( cellClass, forCellReuseIdentifier: "\(cellClass)");
            print("\(cellClass)")
        }
        func numberOfSections(in: UITableView) -> Int {
            return ds!.count
        }
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 44
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return ds![section].count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let arr = ds!
            let a  = dequeueReusableCell(withIdentifier: "\(cellClass)", for: indexPath) ;
            loadCell(a,arr[indexPath.section][indexPath.row])
            return a
        }
        func loadCell(_ cell : UITableViewCell,_ item : Any){
            onCellData_?(cell,item)
        }
    }

原本需要继承并覆盖的loadData现在可以转移为事件，从而砍掉一些不自在的代码。此案例中，还有一处可以稍微优化，就是viewDidLoad内的DoubleString，喜爱Swift的字面量对象的话，可以改写为数组，反正解析的时候，转换为数组就好：


    override func viewDidLoad() {
        super.viewDidLoad()        
        a  = Table()
        a.onCellData = {(cell ,obj) in
            let ds = obj as! [String]
            let c = cell as! DoubleStringCell
            c.l1?.text = ds[0]
            c.l2?.text = ds[1]
        }
        a.cellClass = DoubleStringCell.self
        a.ds = [[["Paris","Charles de Gaulle"],["Rome","FCO"]]]
        a.load()
        a.frame = CGRect(x: 0,y: 50,width: 300,height: 500)
        self.view.addSubview(a)
    }
