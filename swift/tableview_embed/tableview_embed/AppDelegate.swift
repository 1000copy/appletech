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


class Table2 : UITableView,UITableViewDataSource,UITableViewDelegate{
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

class Page1: UIViewController {
    var a : Table!
    override func viewDidLoad() {
        super.viewDidLoad()
        a  = Table()
        a.frame = CGRect(x: 0,y: 50,width: 300,height: 500)
        self.view.addSubview(a)
    }
}


class Table1 : UITableView,UITableViewDataSource,UITableViewDelegate{
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
