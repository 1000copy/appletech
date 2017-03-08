
import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        // Override point for customization after application launch.
        //        self.window!.rootViewController = DatePickerDemo()
        //                self.window!.rootViewController = PageControlDemo()
        //        self.window!.rootViewController =  UISegmentedControlDemo()
        self.window!.rootViewController = UISwitchDemo()
        self.window!.backgroundColor = UIColor.white
        self.window!.makeKeyAndVisible()
        return true
    }
}

//UISwitch
class UISwitchDemo : UIViewController{
    var p :  UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        p =   UISwitch ()
        p.frame = view.frame
        p.frame.origin.y += 40
        p.frame.size.height = 50
        view.addSubview(p)
        p.addTarget(self, action: #selector(UISwitchDemo.changed(_:)), for: .valueChanged)
    }
    func changed (_ sender: AnyObject){
        print(p.isOn)
    }
}

// UIStepper
class UIStepperDemo : UIViewController{
    var p :  UIStepper!
    override func viewDidLoad() {
        super.viewDidLoad()
        p =   UIStepper ()
        p.frame = view.frame
        p.frame.origin.y += 40
        p.frame.size.height = 50
        view.addSubview(p)
        p.addTarget(self, action: #selector(UISwitchDemo.changed(_:)), for: .valueChanged)
        p.maximumValue = 10
        p.minimumValue = 1
        p.value = 5
    }
    func changed (_ sender: AnyObject){
        print(p.value)
    }
}
// UISlider

class UISliderDemo : UIViewController{
    var p :  UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        p =   UISlider ()
        p.frame = view.frame
        p.frame.origin.y += 40
        p.frame.size.height = 50
        view.addSubview(p)
        p.addTarget(self, action: #selector(UISwitchDemo.changed(_:)), for: .valueChanged)
        p.value = 0.5
    }
    func changed (_ sender: AnyObject){
        print(p.value)
    }
}


//UISegmentedControl
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
        p.setImage(UIImage.imageWithColor(UIColor.red), forSegmentAt: 0)
        p.addTarget(self, action: #selector(UISwitchDemo.changed(_:)), for: .valueChanged)
        p.selectedSegmentIndex = 0
    }
    func changed (_ sender: AnyObject){
        print(p.selectedSegmentIndex)
    }
}


class PageControlDemo : UIViewController{
    var p :  UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        p =   UIPageControl ()
        p.numberOfPages = 5
        p.pageIndicatorTintColor = UIColor.blue
        p.currentPageIndicatorTintColor = UIColor.red
        p.frame = view.frame
        p.frame.origin.y += 40
        view.addSubview(p)
        p.addTarget(self, action: #selector(UISwitchDemo.changed(_:)), for: .valueChanged)
        // button 
        let button = UIButton()
        button.frame = view.frame
        button.frame.size.height = 20
        button.frame.origin.y += 20
        button.setTitle("+1", for: UIControlState())
        view.addSubview(button)
        button.addTarget(self, action: #selector(PageControlDemo.addone(_:)), for: .touchDown)
        button.backgroundColor = UIColor.red
    }
    func addone (_ sender: AnyObject){
        let newpage = p.currentPage + 1
        if newpage > p.numberOfPages - 1 {
            p.currentPage = 0
        }else{
           p.currentPage += 1
        }
        
    }
    func changed (_ sender: AnyObject){
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
        p.addTarget(self, action: #selector(UISwitchDemo.changed(_:)), for: .valueChanged)
    }
    func changed (_ sender: AnyObject){
        print(p.date)
    }
}
