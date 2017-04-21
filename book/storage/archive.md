# archive

想把对象序列化到文件，可以首先令此对象符合NSCoding协议，然后使用归档类完成序列化。

如下案例，可以把对象User序列化到文件内：

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
	class User : NSObject,NSCoding{
	    var id : Int32
	    var name : String
	    init(_ id: Int32 ,_ name : String) {
	        self.id = id
	        self.name = name
	    }
	    required convenience init?(coder decoder: NSCoder) {
	        guard let id = decoder.decodeInt32(forKey: "id") as? Int32,
	            let name = decoder.decodeObject(forKey:"name") as? String
	            else { return nil }
	        
	        self.init(id,name)
	    }
	    func encode(with coder: NSCoder) {
	        coder.encode(self.id, forKey: "id")
	        coder.encode(self.name, forKey: "name")
	    }
	    override public var description: String { return "{id:\(id),name:\(name)}" }
	}
	class Page: UIViewController {
	    let filename = "/todo.archive"
	    override func viewDidLoad() {
	        super.viewDidLoad()
	        bar()
	    }
	    func bar(){
	        do {
	            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
	            let path = "\(documentDirectory)\(filename)"
	            let u = User(1,"user")
	            NSKeyedArchiver.archiveRootObject(u, toFile: path)
	            let user1 = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? User
	            print(user1)
	        }catch {print("\(error)")}
	    }
	}



运行后输出的结果:

	Optional({id:1,name:user})

协议NSCoding需要实现两个方法：

	public protocol NSCoding {
	    public func encode(with aCoder: NSCoder)
	    public init?(coder aDecoder: NSCoder) // NS_DESIGNATED_INITIALIZER
	}

方法encode(with:)是从NSCoder内解码数据，方法init?(coder:)是编码数据到NSCoder内。大体上函数内的实现就是一个个的用类似的代码把当前对象的成员做编码和解码。

然后这个对象就可以传递给函数：

		NSKeyedArchiver.archiveRootObject

完成归档，然后使用：

		NSKeyedUnarchiver.unarchiveObject(withFile: path) as? User

完成反归档。

更强大的是，如果对象内有成员指向到其他对象，归档类可以把这些指向对象一起归档，比如User类指向一个Todo列表，那么可以：


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
	class User : NSObject,NSCoding{
	    var id : Int32
	    var name : String
	    var todos : [Todo]
	    init(_ id: Int32 ,_ name : String,_ todos:[Todo]) {
	        self.id = id
	        self.name = name
	    }
	    required convenience init?(coder decoder: NSCoder) {
	        guard let id = decoder.decodeInt32(forKey: "id") as? Int32,
	            let name = decoder.decodeObject(forKey:"name") as? String
	            else { return nil }
	        
	        self.init(id,name)
	    }
	    func encode(with coder: NSCoder) {
	        coder.encode(self.id, forKey: "id")
	        coder.encode(self.name, forKey: "name")
	    }
	    override public var description: String { return "user:{id:\(id),name:\(name)}" }
	}

	class Todo : NSObject,NSCoding{
	    var id : Int32
	    var name : String
	    init(_ id: Int32 ,_ name : String) {
	        self.id = id
	        self.name = name
	    }
	    required convenience init?(coder decoder: NSCoder) {
	        guard let id = decoder.decodeInt32(forKey: "id") as? Int32,
	            let name = decoder.decodeObject(forKey:"name") as? String
	            else { return nil }
	        
	        self.init(id,name)
	    }
	    func encode(with coder: NSCoder) {
	        coder.encode(self.id, forKey: "id")
	        coder.encode(self.name, forKey: "name")
	    }
	    override public var description: String { return "todo:{id:\(id),name:\(name)}" }
	}

	class Page: UIViewController {
	    let filename = "/todo.archive"
	    override func viewDidLoad() {
	        super.viewDidLoad()
	        bar()
	    }
	    func bar(){
	        do {
	            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
	            let path = "\(documentDirectory)\(filename)"
	            let u = User(1,"user")
	            NSKeyedArchiver.archiveRootObject(u, toFile: path)
	            let user1 = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? User
	            print(user1)
	        }catch {print("\(error)")}
	    }
	}




http://www.jianshu.com/p/dee076eda44e


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
    let data:[String:String] = ["key1" : "value1", "key2":"value2", "key3":"value333"]
    override func viewDidLoad() {
        super.viewDidLoad()
//        bar()
        writePropertyList()
        readPropertyList()
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
            readPropertyList()
        }catch {print("\(error)")}
        
    }
    func readPropertyList() {
        var propertyListForamt =  PropertyListSerialization.PropertyListFormat.xml //Format of the Property List.
        var plistData: [String: AnyObject] = [:] //Our data
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = "\(documentDirectory)/\(filename)"
        print(path)
        let plistPath: String? =  path
        let plistXML = FileManager.default.contents(atPath: plistPath!)!
        do {
            plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListForamt) as! [String:AnyObject]
            print(plistData)
            
        } catch {
            print("Error reading plist: \(error), format: \(propertyListForamt)")
        }
    }
    func writePropertyList() {
        var propertyListForamt =  PropertyListSerialization.PropertyListFormat.xml //Format of the Property List.
        var plistData: [String: Any] = data
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = "\(documentDirectory)/\(filename)"
        print(path)
        let plistPath: String? =  path
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(filename)
        let plistXML = FileManager.default.contents(atPath: plistPath!)!
        do {//convert the data to a dictionary and handle errors.
            let o = OutputStream(url:fileURL,append:false)
            PropertyListSerialization.writePropertyList(plistData, to: o!, format: propertyListForamt, options: 0, error: nil)
            print(plistData)
            
        } catch {
            print("Error reading plist: \(error), format: \(propertyListForamt)")
        }
    }
}
class Page1: UIViewController {
    let filename = "/profile.plist"
    let data:[String:String] = ["key1" : "value1", "key2":"value2", "key3":"value3"]
    override func viewDidLoad() {
        super.viewDidLoad()
        foo()
    }
    func foo(){
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = urls[urls.count-1]
        let url = docURL.appendingPathComponent(filename)
        if NSKeyedArchiver.archiveRootObject(data, toFile: url.path) {
            print(true)
        }
        if let loadedDic = NSKeyedUnarchiver.unarchiveObject(withFile: url.path) as? [String:String] {
            print(loadedDic)
        }
    }
    
}


