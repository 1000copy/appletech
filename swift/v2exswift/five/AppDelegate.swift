import UIKit
import FXBlurView
import SnapKit
import SwiftIcons
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow();
        self.window?.frame=UIScreen.main.bounds;
        self.window?.makeKeyAndVisible();
        self.window?.rootViewController = LeftViewController()
        return true
    }
}
class LeftViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var backgroundImageView:UIImageView?
    var frostedView = FXBlurView()
    
    fileprivate var _tableView :UITableView!
    fileprivate var tableView: UITableView {
        get{
            if(_tableView != nil){
                return _tableView!;
            }
            _tableView = UITableView();
            _tableView.backgroundColor = UIColor.clear
            _tableView.estimatedRowHeight=100;
            _tableView.separatorStyle = UITableViewCellSeparatorStyle.none;
            
            regClass(self.tableView, cell: LeftUserHeadCell.self)
            regClass(self.tableView, cell: LeftNodeTableViewCell.self)
            regClass(self.tableView, cell: LeftNotifictionCell.self)
            
            _tableView.delegate = self;
            _tableView.dataSource = self;
            return _tableView!;
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = V2EXColor.colors.v2_backgroundColor;
        
        self.backgroundImageView = UIImageView()
        self.backgroundImageView!.frame = self.view.frame
        self.backgroundImageView!.contentMode = .scaleToFill
        view.addSubview(self.backgroundImageView!)
        
        frostedView.underlyingView = self.backgroundImageView!
        frostedView.isDynamic = true
        frostedView.tintColor = UIColor.black
        frostedView.frame = self.view.frame
        self.view.addSubview(frostedView)
        
        self.view.addSubview(self.tableView);
        self.tableView.snp.makeConstraints{ (make) -> Void in
            make.top.right.bottom.left.equalTo(self.view);
        }
        
        self.backgroundImageView?.image = UIImage(named: "12.jpg")
        self.frostedView.updateAsynchronously(true, completion: nil)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [1,3,2][section]
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 1 && indexPath.row == 2)
            
        {
            return 55+10
        }
        return [180,55+SEPARATOR_HEIGHT,55+SEPARATOR_HEIGHT][indexPath.section]
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if  indexPath.row == 0 {
                let cell = getCell(tableView, cell: LeftUserHeadCell.self, indexPath: indexPath);
                return cell ;
            }
            else {
                return UITableViewCell()
            }
        }
        else if (indexPath.section == 1) {
            if indexPath.row == 1 {
                let cell = getCell(tableView, cell: LeftNotifictionCell.self, indexPath: indexPath)
                cell.nodeImageView.image = UIImage.imageUsedTemplateMode("ic_notifications_none")
                return cell
            }
            else {
                let cell = getCell(tableView, cell: LeftNodeTableViewCell.self, indexPath: indexPath)
                cell.nodeNameLabel.text = ["me","","favorites"][indexPath.row]
                let names = ["ic_face","","ic_turned_in_not"]
                cell.nodeImageView.image = UIImage.imageUsedTemplateMode(names[indexPath.row])
                return cell
            }
        }
        else {
            let cell = getCell(tableView, cell: LeftNodeTableViewCell.self, indexPath: indexPath)
            cell.nodeNameLabel.text = [("nodes"),("more")][indexPath.row]
            let names = ["ic_navigation","ic_settings_input_svideo"]
            cell.nodeImageView.image = UIImage.imageUsedTemplateMode(names[indexPath.row])
            return cell
        }
    }
}
class LeftUserHeadCell: UITableViewCell {
    /// 头像
    var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(white: 0.9, alpha: 0.3)
        imageView.layer.borderWidth = 1.5
        imageView.layer.borderColor = UIColor(white: 1, alpha: 0.6).cgColor
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 38
        return imageView
    }()
    /// 用户名
    var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = v2Font(16)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.setup();
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setup()->Void{
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        
        self.contentView.addSubview(self.avatarImageView)
        self.contentView.addSubview(self.userNameLabel)
        
        self.avatarImageView.snp.makeConstraints{ (make) -> Void in
            make.centerX.equalTo(self.contentView)
            make.centerY.equalTo(self.contentView).offset(-8)
            make.width.height.equalTo(self.avatarImageView.layer.cornerRadius * 2)
        }
        self.userNameLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.avatarImageView.snp.bottom).offset(10)
            make.centerX.equalTo(self.avatarImageView)
        }
        userNameLabel.text = "请先登录"
        avatarImageView.image = UIImage.init(icon: .emoji(.faceGirl), size: CGSize(width: 20, height: 20), textColor: .white, backgroundColor: .clear)
    }
    
}


class LeftNodeTableViewCell: UITableViewCell {
    
    var nodeImageView: UIImageView = UIImageView()
    var nodeNameLabel: UILabel = {
        let label =  UILabel()
        label.font = v2Font(16)
        return label
    }()
    var panel = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.setup();
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup()->Void{
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        
        self.contentView.addSubview(panel)
        panel.addSubview(self.nodeImageView)
        panel.addSubview(self.nodeNameLabel)
        
        panel.snp.makeConstraints{ (make) -> Void in
            make.left.top.right.equalTo(self.contentView)
            make.height.equalTo(55)
        }
        self.nodeImageView.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalTo(panel)
            make.left.equalTo(panel).offset(20)
            make.width.height.equalTo(25)
        }
        self.nodeNameLabel.snp.makeConstraints{ (make) -> Void in
            make.left.equalTo(self.nodeImageView.snp.right).offset(20)
            make.centerY.equalTo(self.nodeImageView)
        }
        
        configureColor()
    }
    func configureColor(){
        self.panel.backgroundColor = V2EXColor.colors.v2_LeftNodeBackgroundColor
        self.nodeImageView.tintColor =  V2EXColor.colors.v2_LeftNodeTintColor
        self.nodeNameLabel.textColor = V2EXColor.colors.v2_LeftNodeTintColor
    }
}


class LeftNotifictionCell : LeftNodeTableViewCell{
    var notifictionCountLabel:UILabel = {
        let label = UILabel()
        label.font = v2Font(10)
        label.textColor = UIColor.white
        label.layer.cornerRadius = 7
        label.layer.masksToBounds = true
        label.backgroundColor = V2EXColor.colors.v2_NoticePointColor
        return label
    }()
    
    override func setup() {
        super.setup()
        self.nodeNameLabel.text = ("notifications")
        self.contentView.addSubview(self.notifictionCountLabel)
        self.notifictionCountLabel.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalTo(self.nodeNameLabel)
            make.left.equalTo(self.nodeNameLabel.snp.right).offset(5)
            make.height.equalTo(14)
        }
    }
    
}

func regClass(_ tableView:UITableView , cell:AnyClass)->Void {
    tableView.register( cell, forCellReuseIdentifier: "\(cell)");
}
class V2EXColor :NSObject  {
    fileprivate static let STYLE_KEY = "styleKey"
    
    static let V2EXColorStyleDefault = "Default"
    static let V2EXColorStyleDark = "Dark"
    
    fileprivate static var _colors:V2EXColorProtocol?
    static var colors :V2EXColorProtocol {
        get{
            
            if let c = V2EXColor._colors {
                return c
            }
            else{
                if V2EXColor.sharedInstance.style == V2EXColor.V2EXColorStyleDefault{
                    return V2EXDefaultColor.sharedInstance
                }
                else{
                    return V2EXDarkColor.sharedInstance
                }
            }
            
        }
        set{
            V2EXColor._colors = newValue
        }
    }
    
    dynamic var style:String
    static let sharedInstance = V2EXColor()
    fileprivate override init(){
        self.style = V2EXColor.V2EXColorStyleDefault
        super.init()
    }

    
}

func colorWith255RGB(_ r:CGFloat , g:CGFloat, b:CGFloat) ->UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 255)
}
func colorWith255RGBA(_ r:CGFloat , g:CGFloat, b:CGFloat,a:CGFloat) ->UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a/255)
}

func createImageWithColor(_ color:UIColor) -> UIImage{
    return createImageWithColor(color, size: CGSize(width: 1, height: 1))
}
func createImageWithColor(_ color:UIColor,size:CGSize) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    UIGraphicsBeginImageContext(rect.size);
    let context = UIGraphicsGetCurrentContext();
    context?.setFillColor(color.cgColor);
    context?.fill(rect);
    
    let theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage!;
}


//使用协议 方便以后切换颜色配置文件、或者做主题配色之类乱七八糟产品经理最爱的功能

protocol V2EXColorProtocol{
    var v2_backgroundColor: UIColor { get }
    var v2_LeftNodeTintColor: UIColor { get }
    var v2_NoticePointColor : UIColor { get }/// 小红点背景颜色
    var v2_LeftNodeBackgroundColor : UIColor { get }
}

class V2EXDefaultColor: NSObject,V2EXColorProtocol {
    static let sharedInstance = V2EXDefaultColor()
    fileprivate override init(){
        super.init()
    }
    
    var v2_backgroundColor : UIColor{
        get{
            return colorWith255RGB(242, g: 243, b: 245);
        }
    }
    var v2_NodeBackgroundColor : UIColor {
        get {
            return colorWith255RGB(242, g: 242, b: 242)
        }
    }
    var v2_LeftNodeTintColor : UIColor {
        get {
            return colorWith255RGBA(0, g: 0, b: 0, a: 140)
        }
    }
    
    var v2_NoticePointColor : UIColor {
        get {
            return colorWith255RGB(207, g: 70, b: 71)
        }
    }
    var v2_LeftNodeBackgroundColor : UIColor {
        get {
            return colorWith255RGBA(255, g: 255, b: 255, a: 76)
        }
    }
}


/// Dark Colors
class V2EXDarkColor: NSObject,V2EXColorProtocol {
    static let sharedInstance = V2EXDarkColor()
    fileprivate override init(){
        super.init()
    }
    
    var v2_backgroundColor : UIColor{
        get{
            return colorWith255RGB(32, g: 31, b: 35);
        }
    }
      var v2_NodeBackgroundColor : UIColor {
        get {
            return colorWith255RGB(40, g: 40, b: 40)
        }
    }
    
    
    var v2_LeftNodeTintColor : UIColor {
        get {
            return colorWith255RGBA(0, g: 0, b: 0, a: 140)
        }
    }
    
    var v2_NoticePointColor : UIColor {
        get {
            return colorWith255RGB(207, g: 70, b: 71)
        }
    }
    var v2_LeftNodeBackgroundColor : UIColor {
        get {
            return colorWith255RGBA(255, g: 255, b: 255, a: 76)
        }
    }
    
}



let SEPARATOR_HEIGHT = 1.0 / UIScreen.main.scale
func getCell<T: UITableViewCell>(_ tableView:UITableView ,cell: T.Type ,indexPath:IndexPath) -> T {
    return tableView.dequeueReusableCell(withIdentifier: "\(cell)", for: indexPath) as! T ;
}
func v2Font(_ fontSize: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: fontSize);
}
extension UIImage {
    class func imageUsedTemplateMode(_ named:String) -> UIImage? {
        print(named)
        // 2x = 20X20
        let a :[EmojiType] = [.faceMan, .alarm,.digg, .aleph, .atom, .spider]
        let b :[String] = ["ic_face",
            "ic_notifications_none",
            "ic_turned_in_not",
            "ic_navigation",
            "ic_settings_input_svideo"]
        let image = UIImage.init(icon: .emoji(a[b.index(of:named)!]), size: CGSize(width: 20, height: 20), textColor: .white, backgroundColor: .clear)
        return image
    }
}
