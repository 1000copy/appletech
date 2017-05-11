
## ProgressView

进度条类UIProgressView用来显示进度。

如下案例显示一个进度条：

	import UIKit
	@UIApplicationMain
	class AppDelegate: UIResponder, UIApplicationDelegate {
	    var window: UIWindow?
	    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
	        self.window = UIWindow(frame: UIScreen.main.bounds)
	        self.window!.rootViewController = Page()
	        self.window?.makeKeyAndVisible()
	        return true
	    }
	}
	class Page: UIViewController{
	    var timer : Timer!
	    var pv: UIProgressView!
	    var pv1: UIProgressView!
	    override func viewDidLoad() {
	        super.viewDidLoad()
	        view.backgroundColor = UIColor.white
	        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(Page.update), userInfo: nil, repeats: true)
	        pv = UIProgressView()
	        pv.frame = CGRect(x: 100, y: 100, width: 100, height: 10)
	        view.addSubview(pv)
	        pv.progress = 0.51
	        pv.progressViewStyle = .bar

	    }
	    func update() {
	        pv.progress = pv.progress +  0.01
	        if pv.progress >= 1 {
	            pv.progress = 0
	        }
	    }
	}

运行后，界面上显示一个蓝色的、自动推进的进度条。

特别注意的是，进度值范围从0到1，而不是从0到100，如果需要一个刻度的进展，那么在属性progress的值上加0.01即可。