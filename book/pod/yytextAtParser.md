第三方库YYText可以完成富文本的输入，如果需要创建类似微博@一样的输入UI，可以使用它的YYTextView组件。具体说：

1. 当内容中有@打头的文字，可以分析出来，并以不同的颜色显示
2. 当删除时，可以把@文字整体删除

首先需要引用YYText，我们的Podfile：

    platform:ios,'9.0'
    inhibit_all_warnings!
    use_frameworks!
    def pods
        pod 'YYText', '~> 1.0.7'
    end
    target 'V2ex-Swift' do
        pods
    end

执行：
	
	pod install --verbose --no-repo-update

代码如下：


	import UIKit
	@UIApplicationMain
	class AppDelegate: UIResponder, UIApplicationDelegate {
	    var window: UIWindow?
	    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
	        self.window = UIWindow(frame: UIScreen.main.bounds)
	        let page = Page()
	        self.window!.rootViewController = page
	        self.window?.makeKeyAndVisible()
	        return true
	    }
	}
	import YYText
	class AtParser: NSObject ,YYTextParser{
	    var regex:NSRegularExpression
	    override init() {
	        self.regex = try! NSRegularExpression(pattern: "@(\\S+)\\s", options: [.caseInsensitive])
	        super.init()
	    }
	    func parseText(_ text: NSMutableAttributedString?, selectedRange: NSRangePointer?) -> Bool {
	        guard let text = text else {
	            return false;
	        }
	        self.regex.enumerateMatches(in: text.string, options: [.withoutAnchoringBounds], range: text.yy_rangeOfAll()) { (result, flags, stop) -> Void in
	            if let result = result {
	                let range = result.range
	                if range.location == NSNotFound || range.length < 1 {
	                    return ;
	                }
	                if  text.attribute(YYTextBindingAttributeName, at: range.location, effectiveRange: nil) != nil  {
	                    return ;
	                }
	                let bindlingRange = NSMakeRange(range.location, range.length-1)
	                let binding = YYTextBinding()
	                binding.deleteConfirm = true ;
	                text.yy_setTextBinding(binding, range: bindlingRange)
	                text.yy_setColor(.blue, range: bindlingRange)
	            }
	        }
	        return false;
	    }
	}
	class Page: UIViewController ,YYTextViewDelegate {
	    var textView:TextView?
	    override func viewDidLoad() {
	        super.viewDidLoad()
	        self.textView = TextView()
	        self.textView!.frame = view.frame
	        self.textView!.delegate = self
	        self.view.addSubview(self.textView!)
	    }
	}
	class TextView :YYTextView{
	    override func layoutSubviews() {
	        backgroundColor = .yellow
	        scrollsToTop = false
	        text  = "\n\n\n42 empty lines removed by @someone ,"
	        textColor = .red
	        textParser = AtParser()
	    }
	}
执行后，可以发现：

1. 默认输入的文字中，@打头的为蓝色文字，其他为红色
2. 当自己输入文字是，@打头的为蓝色文字，其他为红色
3. 当删除时，文字会把背景色套住，再次按删除按钮时才会真的删除

代码中需要说的是YYTextParser，它可以创建实例，赋值给YYTextView.textParser，这样就可以使用它分析当前的输入文字，如果正则表达式匹配成功，就可以为这截文字赋予不同的颜色或者其他什么操作，以便显示它和其他文字的不同。


