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
        var count = 0
        var label : PKHUDSuccessView!
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = .white
            label   = PKHUDSuccessView()
            label.frame = CGRect(x: 100, y: 100, width: 20, height: 50)
            label.text =  "0"
            view.addSubview(label)
            let button   = UIButton(type: .system)
            button.frame = CGRect(x: 120, y: 100, width: 20, height: 50)
            button.setTitle("+",for: .normal)
            button.addTarget(self, action: #selector(Page1.buttonAction(_:)), for: .touchUpInside)
            view.addSubview(button)
        }
        func buttonAction(_ sender:UIButton!){
            self.count +=  1
            label.text =  self.count.description
        }
    }


//SVProgressHUD.setForegroundColor(UIColor(white: 1, alpha: 1))
//SVProgressHUD.setBackgroundColor(UIColor(white: 0.15, alpha: 0.85))
/// PKHUDCheckmarkView provides an animated success (checkmark) view.
class PKHUDSuccessView:UIView{

    var checkmarkShapeLayer: CAShapeLayer = {
        let checkmarkPath = UIBezierPath()
        checkmarkPath.move(to: CGPoint(x: 4.0, y: 27.0))
        checkmarkPath.addLine(to: CGPoint(x: 34.0, y: 56.0))
        checkmarkPath.addLine(to: CGPoint(x: 88.0, y: 0.0))

        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 3.0, y: 3.0, width: 88.0, height: 56.0)
        layer.path = checkmarkPath.cgPath
        layer.fillMode = kCAFillModeForwards
        layer.lineCap     = kCALineCapRound
        layer.lineJoin    = kCALineJoinRound
        layer.fillColor   = nil
//        layer.fillColor = UIColor(white: 0.15, alpha: 0.85).cgColor
//        layer.strokeColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0).cgColor
        layer.strokeColor = UIColor(white: 1, alpha: 1).cgColor
        layer.lineWidth   = 6.0
        return layer
    }()

    public init(title: String? = nil, subtitle: String? = nil) {
        super.init(title: title, subtitle: subtitle)
        layer.addSublayer(checkmarkShapeLayer)
        backgroundColor = UIColor(white: 0.15, alpha: 0.85)
        checkmarkShapeLayer.position = layer.position
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.addSublayer(checkmarkShapeLayer)
        checkmarkShapeLayer.position = layer.position
    }

    open func startAnimation() {
        let checkmarkStrokeAnimation = CAKeyframeAnimation(keyPath:"strokeEnd")
        checkmarkStrokeAnimation.values = [0, 1]
        checkmarkStrokeAnimation.keyTimes = [0, 1]
        checkmarkStrokeAnimation.duration = 0.35

        checkmarkShapeLayer.add(checkmarkStrokeAnimation, forKey:"checkmarkStrokeAnim")
    }

    open func stopAnimation() {
        checkmarkShapeLayer.removeAnimation(forKey: "checkmarkStrokeAnimation")
    }
}