使用动态文字填充UITableViewCell内容时，需要计算文字占用高度，以便告知UITableViewCell的行高。使用YYText的YYTextLayout可以帮助做到这点。

如下案例，简单封装了YYTextLayout，并通过两个案例调用，演示它的做法：

    import UIKit
    import YYText
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            let a = "I'm trying to import myFramework into a project. I've added ... If I get you correctly you don't have a separate build target for your framework (you"
            print(Foo.OccupyHigh(a,UIScreen.main.bounds.size.width - 24))
            print(Foo.OccupyHigh(a+a,UIScreen.main.bounds.size.width - 24))
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


核心为OccupyHigh函数，告诉它文字的内容和希望的宽度，就可以得到它的占用高度。