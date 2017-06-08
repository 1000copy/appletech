import UIKit
import MJRefresh
import Kingfisher
import ObjectMapper
import Ji
import YYText
import KeychainSwift
import SnapKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        let nav = UINavigationController()
        window!.rootViewController = nav
        nav.pushViewController(Page(), animated: true)
        //        window!.rootViewController = Page()
        window!.rootViewController!.view.backgroundColor = .blue
        window!.makeKeyAndVisible()
        return true
    }
}
class Foo {
    class func getYYLayout(_ title : String?)->YYTextLayout?{
        return getYYLayout(title,UIScreen.main.bounds.size.width - 24)
    }
    class func getYYLayout(_ title : String?, _ width : CGFloat)->YYTextLayout?{
        var topicTitleAttributedString: NSMutableAttributedString?
        var topicTitleLayout: YYTextLayout?
        let r :CGFloat = 15.0
        let g :CGFloat = 15.0
        let b :CGFloat = 15.0
        topicTitleAttributedString = NSMutableAttributedString(string: title!,
                                                               attributes: [
                                                                NSFontAttributeName:v2Font(17),
                                                                NSForegroundColorAttributeName:UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 255),
                                                                ])
        topicTitleAttributedString?.yy_lineSpacing = 3
        topicTitleLayout = YYTextLayout(containerSize: CGSize(width: width, height: 9999), text: topicTitleAttributedString!)
        return topicTitleLayout
    }
    class func OccupyHigh(_ title : String, _ width : CGFloat) -> CGFloat{
        let topicTitleLayout = getYYLayout(title,width)
        return topicTitleLayout?.textBoundingRect.size.height ?? 0
    }
}
