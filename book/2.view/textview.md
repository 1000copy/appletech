
## TextView

UITextView代表了一个多行的、可滚动的、可编辑的内容区域。

代码示例如下：

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
	class Page: UIViewController,UITextViewDelegate{
	    var c : UITextView!
	    override func viewDidLoad() {
	        super.viewDidLoad()
	        c = UITextView()
	        c.frame = CGRect(x: 10, y: 50, width: 200, height: 400)
	        view.addSubview(c)
	        c.text = "text\nand new lines\nand more lines"
	        c.delegate = self
	    }		    
	    func textViewDidChange(_ textView: UITextView){
	        print ("new value : \(c.text)")
	    }
	}

执行后，可以看到一个矩形区域，内部有一些文字。当在此区域内输入内容时，会在控制台打印新的内容。

和其他视图一样，TextView的使用过程如下：

1. 实例化
2. 设置大小位置
3. 加入父视图

实现协议UITextViewDelegate的话，可以在类内接受事件，比如：

	func textViewDidChange(_ textView: UITextView){
        print ("new value : \(c.text)")
    }

此事件会在内容改变时得到调用。
