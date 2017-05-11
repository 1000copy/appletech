
## CollectionView

类UICollectionView管理一个有序的数据项目集合，并使用定制的布局展示它们。

假设我们希望以流式布局方式来显示一个多部分的集合，第一个部分是计算机语言，第二个部分是操作系统，像是这样：

    [["Java","Swift","JavaScript","PHP","Python"],["OS X","Windows","Linux"]]

那么，使用UICollectionView是非常恰当的，示例代码如下：

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
    class Page: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
        var items = [["Java","Swift","JavaScript","PHP","Python"],["OS X","Windows","Linux"]]
        var collectionView: UICollectionView!
        override func viewDidLoad() {
            super.viewDidLoad()
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            layout.itemSize = CGSize(width: 80, height: 60)
            var frame = view.frame
            frame.origin.y += 30
            collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
            collectionView.dataSource = self
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
            collectionView.backgroundColor = UIColor.white
            self.view.addSubview(collectionView)
        }
        func numberOfSections(in collectionView: UICollectionView) -> Int{
            return items.count
        }
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return items[section].count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            cell.backgroundColor = .blue
            let l = UILabel()
            l.text = items[indexPath.section][indexPath.row]
            l.frame =  CGRect(x: 0.0, y: 0.0, width: 100.0,height: 20.0 )
            cell.addSubview(l)
            return cell
        }
    }
        
此类也需要实现一个数据源协议：UICollectionViewDataSource。通过此协议实现，可以告知UICollectionView需要展示的数据源的必要信息：

1. 有多少部分
2. 每个部分有多少项目
3. 每个项目的Cell实例。

本文中的Cell实例内有一个UILabel的子视图，其文本内容就是要展示的项目的文本内容。

在函数

     func viewDidLoad() 

中，使用了UICollectionViewFlowLayout作为UICollectionView的布局管理类。此布局类可以通过属性sectionInset指定每个Cell的四方位置的空隙，可以通过属性itemSize指定每个Cell的大小。

