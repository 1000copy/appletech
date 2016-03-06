
import UIKit

//UISegmentedControl 
extension UIImage {
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, 10.0,10.0 )
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
class UISegmentedControlDemo : UIViewController{
    var p :  UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        p =   UISegmentedControl (items:["1","2","3"])
        p.frame = view.frame
        p.frame.origin.y += 40
        p.frame.size.height = 50
        view.addSubview(p)
        // A segment may either have a text title or an image, but not both
        p.setImage(UIImage.imageWithColor(UIColor.redColor()), forSegmentAtIndex: 0)
        p.addTarget(self, action: "changed:", forControlEvents: .ValueChanged)
        p.selectedSegmentIndex = 0
    }
    func changed (sender: AnyObject){
        print(p.selectedSegmentIndex)
    }
}


class PageControlDemo : UIViewController{
    var p :  UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        p =   UIPageControl ()
        p.numberOfPages = 5
        p.pageIndicatorTintColor = UIColor.blueColor()
        p.currentPageIndicatorTintColor = UIColor.redColor()
        p.frame = view.frame
        p.frame.origin.y += 40
        view.addSubview(p)
        p.addTarget(self, action: "changed:", forControlEvents: .ValueChanged)
        // button 
        let button = UIButton()
        button.frame = view.frame
        button.frame.size.height = 20
        button.frame.origin.y += 20
        button.setTitle("+1", forState: .Normal)
        view.addSubview(button)
        button.addTarget(self, action: "addone:", forControlEvents: .TouchDown)
        button.backgroundColor = UIColor.redColor()
    }
    func addone (sender: AnyObject){
        let newpage = p.currentPage + 1
        if newpage > p.numberOfPages - 1 {
            p.currentPage = 0
        }else{
           p.currentPage += 1
        }
        
    }
    func changed (sender: AnyObject){
        print(p.currentPage)
    }
}
class DatePickerDemo : UIViewController{
    var p :  UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        p =   UIDatePicker ()
        p.frame = view.frame
        view.addSubview(p)
        p.addTarget(self, action: "changed:", forControlEvents: .ValueChanged)
    }
    func changed (sender: AnyObject){
        print(p.date)
    }
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        // Override point for customization after application launch.
//        self.window!.rootViewController = DatePickerDemo()
//                self.window!.rootViewController = PageControlDemo()
        self.window!.rootViewController =  UISegmentedControlDemo()
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()
        return true
    }
}

