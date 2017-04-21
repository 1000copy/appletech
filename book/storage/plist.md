## plist

plist是一个XML的子集，使用UTF-8编码的文本文件，它的根节点是一个字典，内容由多个主键和值构成。常常用来存储App的配置信息。

可以直接使用NSDictionary类直接存储它的内容到plist内，比如这样：

    import UIKit
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        var window : UIWindow?
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            window = UIWindow()
            window!.rootViewController = Page()
            window!.rootViewController!.view.backgroundColor = .blue
            window!.makeKeyAndVisible()
            return true
        }
    }
    class Page: UIViewController {
        let filename = "/profile.plist"
        let data:[String:String] = ["key1" : "value1", "key2":"value2", "key3":"value3"]
        override func viewDidLoad() {
            super.viewDidLoad()
            bar()
        }
        func bar(){
            do {
                let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
                let path = "\(documentDirectory)/\(filename)"
                print(path)
                let dict = NSDictionary(dictionary: data)
                let isWritten = dict.write(toFile: path, atomically: true)
                let dict1 = NSDictionary(contentsOfFile: path)
                print(dict1)
                print("file created: \(isWritten)")
                let text = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                print(text)
            }catch {print("\(error)")}
            
        }
    }
类NSDictionary的方法write可以指定文件名，然后写入到指定文件。初始化方法 NSDictionary(contentsOfFile:)可以读取plist到词典对象内。

因为plist是UTF-8编码的文本文件，所以，可以使用String打开此文件，输出内容如下（去掉主题无关的文件头后）：

    <plist version="1.0">
    <dict>
        <key>key1</key>
        <string>value1</string>
        <key>key2</key>
        <string>value2</string>
        <key>key3</key>
        <string>value3</string>
    </dict>
    </plist>
