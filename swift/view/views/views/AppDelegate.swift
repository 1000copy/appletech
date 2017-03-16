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
        class Page: UIViewController {
            override func viewDidLoad() {
                super.viewDidLoad()
                var verticalStackView: UIStackView!
                verticalStackView = UIStackView()
                verticalStackView.axis = .vertical
                verticalStackView.distribution = .fillEqually
                verticalStackView.spacing = 10
                let blue = UILabel()
                blue.backgroundColor = .blue
                let green = UILabel()
                green.backgroundColor = .green
                let horizontalStackView = UIStackView()
                horizontalStackView.axis = .horizontal
                horizontalStackView.distribution = .fillEqually
                horizontalStackView.spacing = 10
                horizontalStackView.addArrangedSubview(blue)
                horizontalStackView.addArrangedSubview(green)
                let red = UILabel()
                red.backgroundColor = .red
                red.heightAnchor.constraint(equalToConstant: 34).isActive = true
                verticalStackView.addArrangedSubview(horizontalStackView)
                verticalStackView.addArrangedSubview(red)
                verticalStackView.frame = view.bounds
                view.addSubview(verticalStackView)
            }
        }
//        greenImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        blueImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true

class Page101: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let s   = UIStackView()
        s.translatesAutoresizingMaskIntoConstraints = false;
        
        s.axis  = .vertical
        s.spacing   = 6
        
        let label1 = UILabel()
        label1.backgroundColor = UIColor.blue
        label1.text  = "Hallo"
        let label2 = UILabel()
        label2.backgroundColor = UIColor.yellow
        label2.text  = "Hi"
        let label3 = UILabel()
        label3.backgroundColor = UIColor.red
        label3.text  = "Hello"
        let stackView   = UIStackView()
        stackView.axis  = .horizontal
        stackView.spacing   = 6
        stackView.addArrangedSubview(label1)
        stackView.addArrangedSubview(label2)
        stackView.addArrangedSubview(label3)
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        s.addArrangedSubview(stackView)
        
        let label21 = UILabel()
        label21.backgroundColor = UIColor.blue
        label21.text  = "Hallo"
        let label22 = UILabel()
        label22.backgroundColor = UIColor.yellow
        label22.text  = "Hi"
        let label23 = UILabel()
        label23.backgroundColor = UIColor.red
        label23.text  = "Hello"
        let stackView2   = UIStackView()
        stackView2.axis  = .horizontal
        stackView2.spacing   = 6
        stackView2.addArrangedSubview(label21)
        stackView2.addArrangedSubview(label22)
        stackView2.addArrangedSubview(label23)
        stackView2.translatesAutoresizingMaskIntoConstraints = false;
        s.addArrangedSubview(stackView2)
        
        let label31 = UILabel()
        label31.backgroundColor = UIColor.blue
        label31.text  = "Hallo"
        let label32 = UILabel()
        label32.backgroundColor = UIColor.yellow
        label32.text  = "Hi"
        let label33 = UILabel()
        label33.backgroundColor = UIColor.red
        label33.text  = "Hello"
        let stackView3   = UIStackView()
        stackView3.axis  = .horizontal
        stackView3.spacing   = 6
        stackView3.addArrangedSubview(label31)
        stackView3.addArrangedSubview(label32)
        stackView3.addArrangedSubview(label33)
        stackView3.translatesAutoresizingMaskIntoConstraints = false;
        s.addArrangedSubview(stackView3)
//        s.frame = view.bounds
        view.addSubview(s)
        
    }
}
