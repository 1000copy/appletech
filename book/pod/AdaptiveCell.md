 有时候，需要动态调整UITableView的Cell高度，比如内部有一个TextView，内容由用户决定，可长可短的情况下，肯定是希望Cell和TextView可以展示全部内容，因此也需要Cell高度也跟着同步越高了。
 
 如下代码，展示一个长度变化的TextView，当内容变化时，Cell高度会跟着变化。当通过UITableView.reloadData加载数据时，会触发高度计算函数：
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
 
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
    class Table : UITableView,UITableViewDataSource,UITableViewDelegate{
        let oldstr = "swift"
        let newstr = "The powerful programming language that is also easy to learn. Swift is a powerful and intuitive programming language for macOS, iOS, watchOS and tvOS."
        var arr = [""]
        var textView : UITextView = UITextView()
        override init(frame: CGRect, style: UITableViewStyle) {
            super.init(frame:frame,style:style)
            arr = [oldstr]
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
            textView.frame = a.contentView.frame
            textView.text = arr[indexPath.row]
            a.contentView.addSubview(textView)
            return a
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
            
            textView.frame.size.height = textHeight()
            return textView.frame.height
        }
        func textHeight()-> CGFloat{
            let size = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
            return size.height
        }
    }
    class Page: UIViewController {
        var a : Table!
        override func viewDidLoad() {
            super.viewDidLoad()
            a  = Table()
            a.frame = CGRect(x: 0,y: 100,width: 300,height: 100)
            self.view.addSubview(a)
            let btn = UIButton()
            btn.frame = CGRect(x: 0,y: 200,width: 100,height: 20)
            btn.setTitle("BigString", for: .normal)
            btn.addTarget(self, action: #selector(tap), for: .touchDown)
            self.view.addSubview(btn)
        }
        func tap(){
            if a.arr == [a.newstr]{
                a.arr = [a.oldstr]
            }else{
                a.arr = [a.newstr]
            }
            a.reloadData()
        }
    }

还有一种比较超脱的方式，就是监视textView.contentSize的变化，然后通知TableView重新装入数据，从而引发高度的重新计算。代码如下：

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
        let oldstr = "swift"
        let newstr = "The powerful programming language that is also easy to learn. Swift is a powerful and intuitive programming language for macOS, iOS, watchOS and tvOS."
        var arr = [""]
        var textView : UITextView = UITextView()
        override init(frame: CGRect, style: UITableViewStyle) {
            super.init(frame:frame,style:style)
            arr = [oldstr]
            self.dataSource = self
            self.delegate = self
            self.kvoController.observe(self.textView, keyPath: "contentSize", options: [.new]) {
                [weak self] (observe, observer, change) -> Void in
                    self!.reloadData()
            }
        }
        required init?(coder aDecoder: NSCoder) {
            super.init(coder:aDecoder)
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arr.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let a = UITableViewCell(style: .default, reuseIdentifier: nil)
            textView.frame = a.contentView.frame
            textView.text = arr[indexPath.row]
            a.contentView.addSubview(textView)
            return a
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
            textView.frame.size.height = textHeight()
            return textView.frame.height
        }
        func textHeight()-> CGFloat{
            let size = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
            return size.height
        }
    }
    class Page: UIViewController {
        var a : Table!
        override func viewDidLoad() {
            super.viewDidLoad()
            a  = Table()
            a.frame = CGRect(x: 0,y: 100,width: 300,height: 100)
            self.view.addSubview(a)
            let btn = UIButton()
            btn.frame = CGRect(x: 0,y: 200,width: 100,height: 20)
            btn.setTitle("BigString", for: .normal)
            btn.addTarget(self, action: #selector(tap), for: .touchDown)
            self.view.addSubview(btn)
        }
        func tap(){
            if a.arr == [a.newstr]{
                a.arr = [a.oldstr]
            }else{
                a.arr = [a.newstr]
            }
            a.textView.text = a.arr[0]
        }
    }

这里使用了一个组件，是facebook开源的KVOController。因此需要使用Pod加入依赖并安装它。