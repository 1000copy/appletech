在iOS 7后，UIView新增加了一个tintColor属性，这个属性表示的是“色调”，一旦设置颜色给它，那么以此视图为根视图的整个视图层次结构都会被修改颜色。从而可以不必一一赋值就可以在视图体系内得到一致的颜色体系。

如下代码当点击RUN按钮时，整个以self.view为根视图的视图体系内的所有视图的颜色都会跟着在红黄蓝三种色调内切换：

    import UIKit
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        var window: UIWindow?
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let page = Page1()
            self.window!.rootViewController = page
            self.window?.makeKeyAndVisible()
            return true
        }
    }
    class Page1: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = .white
            let f = FrameView(frame: view.frame)
            
            self.view.addSubview(f)
            
        }
    }
    class FrameView:UIView{
        var label : UILabel!
        var count = 0
        override func tintColorDidChange() {
            self.label.textColor = self.tintColor;
        }
        func buttonAction(_ sender:UIButton!){
            self.tintColor = [UIColor.red,UIColor.yellow,UIColor.blue][count]
            count += 1
            if count == 3{
                count = 0
            }
        }
        override init(frame: CGRect) {
            super.init(frame:frame)
            label   = UILabel()
            label.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
            label.text =  "label tint color"
            label.textAlignment = .left
            self.addSubview(label)
            let button   = UIButton(type: .system)
            button.frame = CGRect(x: 120, y: 150, width: 200, height: 50)
            button.setTitle("RUN",for: .normal)
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            self.addSubview(button)
            let s   = UISlider()
            s.frame = CGRect(x: 120, y: 200, width: 200, height: 50)
            s.value =  0.5
            self.addSubview(s)
            let p   = UIProgressView()
            p.frame = CGRect(x: 120, y: 250, width: 200, height: 50)
            p.progress =  0.5
            self.addSubview(p)
            let stper   = UIStepper()
            stper.frame = CGRect(x: 120, y: 300, width: 200, height: 50)
            self.addSubview(stper)
            let imageView = UIImageView()
            imageView.image = UIImage.imageWithColor(.red)
            imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
            imageView.frame = CGRect(x: 120, y: 350, width: 200, height: 50)
            self.addSubview(imageView)
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
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

只有一个除外，就是label。它是不会随着上级视图的tint修改而跟着改的。如果想要跟着修改，那么需要覆盖方法：
    
    override func tintColorDidChange()

自己设置此颜色给label。
还有一个做了特殊处理的视图，是ImageView。图片都是固定的图，如何根据色调的变化而跟着修改颜色呢？

设置图片的imageWithRenderingMode属性为AlwaysTemplate，这样渲染图片时会将其渲染为一个模板而忽略它的颜色信息，这意味着，对一个像素而言，如果它的alpha值为1的话，就将它的颜色设置为tint color；如果不为1的话，则设置为透明的。
