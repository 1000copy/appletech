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
