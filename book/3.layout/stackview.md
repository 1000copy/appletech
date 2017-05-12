## StackView

有很多布局可以使用横向布局和纵向布局来组合完成，此种情况下，可以使用UIStackView来简化创建布局。

假设我们想要横向布局3个标签，标签之间有边距的话，可以这样：

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
            self.view.addSubview(stackView)
        }
    }

创建标签实例并初始化后，就可以直接丢进UIStackView容器内，比较特别的是，如果想要让UIStackView管理加入控件的布局，必须使用addArrangedSubview，而不是addSubview方法。使用UIStackView布局，你不需要指定视图的位置，也常常不需要指定大小，因为UIKit会帮你自动计算位置和大小。

可以让此容器实例通过“轴向”属性：

    .axis  = .horizontal

设置为横向布局，这样就可以让加入的视图逐个水平方向的排过去。这个属性还可以取值为vertical来设置为垂直方向排布。而通过属性：

    .spacing   = 6

可以设置被布局的子视图之间的距离为6。


### 嵌套使用

把StackView的横向布局和纵向布局组合使用起来，可以做出更加灵活和复杂的布局。比如把三个横向的StackView一起放到一个纵向的容器内。假设我们想要做一个案例，它有一个纵向布局，其内有一个横向布局和一个标签，横向布局中有两个标签。层次结构看起来是这样的：

    verticalStackView
    --horizontalStackView
    ----label
    ----label
    --label

那么，完成此布局的代码如下：

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

属性distribution这里使用了一个新值：

        verticalStackView.distribution = .fillEqually

指示在StackView内的视图均等的填充全部的空间。此属性还可以取值如下：

1. Fill 让其中一个子视图占据最大空间，其他视图为自然大小。
2. FillEqually 调整每个视图，等量占完全部空间。
3. FillProportionally 每个视图等比的拉伸以便填满空间。比如一个视图长度100，另外一个视图长度200，等需要等比拉伸时，可能一个长度变成150，另外一个变成300
4. EqualSpacing调整视图间的间隙而不是拉伸视图的方法来填满空间
5. EqualCentering会努力让每个子视图的中心点之间是等空间的

