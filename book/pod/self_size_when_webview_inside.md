Cell高度自适应的问题真多。现在，如果内部有webView，内容动态装入，大小也是各不相同的，并且高度必须根据内容，而不是view本身的高度来适应，怎么办呢？特别是如果有多个webView的情况下。
这样就可以了：

```swift
  import UIKit
  @UIApplicationMain
  class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = TableViewController()
        return true
    }
  }
  class Cell:UITableViewCell{
    var webView = UIWebView()
    override func layoutSubviews() {
        self.contentView.addSubview(webView)
    }
  }
  class TableViewController: UITableViewController, UIWebViewDelegate
  {
    fileprivate let reuserId = "BookTableViewCellIdentifier"
    override func viewDidLoad() {
        self.tableView.register(Cell.self, forCellReuseIdentifier: reuserId)
    }
    var content : [String] = ["test1<br>test1<br>test1<br>test1<br>", "test22<br>test22<br>test22<br>test22<br>test22<br>test22"]
    var contentHeights : [CGFloat] = [0.0, 0.0]
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuserId, for: indexPath) as! Cell
        let htmlString = content[indexPath.row]
        var htmlHeight = contentHeights[indexPath.row]
        if htmlHeight == 0.0{
            htmlHeight = 100
        }
        cell.webView.tag = indexPath.row
        cell.webView.delegate = self
        cell.webView.loadHTMLString(htmlString, baseURL: nil)
        cell.webView.frame = CGRect(x:10, y:0, width:cell.frame.size.width, height:htmlHeight)
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return contentHeights[indexPath.row]
    }
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        if (contentHeights[webView.tag] != 0.0)
        {
            // we already know height, no need to reload cell
            return
        }
        contentHeights[webView.tag] = webView.scrollView.contentSize.height
        print(contentHeights)
        tableView.reloadRows(at: [IndexPath(row: webView.tag, section:0)], with: .automatic)
    }
  }
```

首先webview只有装入内容完成，才知道内容的高度的，因此需要通过委托，监听事件webViewDidFinishLoad，在此处获得高度。

其次，多个webview会需要在一个事件内监听，因此，必须区别它们，代码中采用了webview.tag属性，赋值为此webview的cell的indexPath，把它记录到高度数组内。如果数组内的高度有值了，那么就不必在写入了。

最后，tableView是可以局部刷新的，那个高度变了就重新装入那个cell，做法就是使用reloadRows方法即可。


