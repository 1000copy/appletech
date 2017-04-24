## Archive

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

更强大的是，如果对象内有成员指向到其他对象，归档类可以把这些指向对象一起归档，比如Man类通过成员wife指向一个Woman类，那么可以连同此成员对象一起做归档。方法如下：


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
	class Man : NSObject,NSCoding{
	    var id : Int32
	    var name : String
	    var wife : Woman
	    init(_ id: Int32 ,_ name : String,_ wife : Woman) {
	        self.id = id
	        self.name = name
	        self.wife = wife
	    }
	    required convenience init?(coder decoder: NSCoder) {
	        guard let id = decoder.decodeInt32(forKey: "id") as? Int32,
	            let name = decoder.decodeObject(forKey:"name") as? String,
	            let todo = decoder.decodeObject(forKey:"wife") as? Woman
	            else { return nil }
	        
	        self.init(id,name,todo)
	    }
	    func encode(with coder: NSCoder) {
	        coder.encode(self.id, forKey: "id")
	        coder.encode(self.name, forKey: "name")
	        coder.encode(wife,forKey:"wife")
	        
	    }
	    override public var description: String { return "Man:{id:\(id),name:\(name)},\(wife)" }
	}

	class Woman : NSObject,NSCoding{
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
	    override public var description: String { return "wife:{id:\(id),name:\(name)}" }
	}

	class Page: UIViewController {
	    let filename = "/man.archive"
	    override func viewDidLoad() {
	        super.viewDidLoad()
	        bar()
	    }
	    func bar(){
	        do {
	            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
	            let path = "\(documentDirectory)\(filename)"
	            let u = Man(1,"Man1",Woman(1,"Wife1"))
	            NSKeyedArchiver.archiveRootObject(u, toFile: path)
	            let user1 = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? Man
	            print(user1)
	        }catch {print("\(error)")}
	    }
	}

要点在于，在NSCoder协议需要的两个函数中，通过NSCoder对象，归档和反归档此成员对象，并且此成员对象也必须指向NSCoder协议即可。

如果成员对象是一个对象的数组，做法是类似的。如下案例有两个类，Department和Task。Department通过成员Tasks包含一个Task的数组。把Task数组整体作为一个对象来处理，使用NSCoder.encode函数即可做归档，使用NSCoder.decodeObject即可反归档：


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
	class Department: NSObject, NSCoding {
	    var name = ""
	    var manager = ""
	    
	    var tasks: [Task]?
	    
	    func encode(with aCoder: NSCoder) {
	        aCoder.encode(name, forKey: "name")
	        aCoder.encode(manager, forKey: "manager")
	        aCoder.encode(tasks, forKey: "taskArray")
	    }
	    
	    required convenience init?(coder aDecoder: NSCoder){
	        self.init()
	        
	        name = aDecoder.decodeObject(forKey: "name") as! String
	        manager = aDecoder.decodeObject(forKey: "manager") as! String
	        tasks = aDecoder.decodeObject(forKey: "taskArray") as? [Task]
	    }
	    override public var description: String { return "dept:{name:\(name),tasks:\(tasks)" }
	    override init() {
	        super.init()
	        name = "D1"
	        manager = "TJ"
	        tasks = []
	        tasks?.append(Task("A1","N1"))
	        tasks?.append(Task("A2","N2"))
	        tasks?.append(Task("A3","N3"))
	    }
	}

	class Task: NSObject, NSCoding {
	    var title = ""
	    var notes = ""
	    override public var description: String { return "{title:\(title)}" }
	    func encode(with aCoder: NSCoder)  {
	        // Methods
	        aCoder.encode(title, forKey: "title")
	        aCoder.encode(notes, forKey: "notes")
	    }
	    
	    required convenience init?(coder aDecoder: NSCoder) {
	        // Methods
	        
	        let title = aDecoder.decodeObject(forKey: "title") as! String
	        let notes = aDecoder.decodeObject(forKey: "notes") as! String
	        self.init(title,notes)
	    }
	    
	    init(_ title:String, _ notes : String) {
	        self.title = title
	        self.notes = notes
	        super.init()
	    }
	}

	class Page: UIViewController {
	    let filename = "/man.archive"
	    override func viewDidLoad() {
	        super.viewDidLoad()
	        bar()
	    }
	    func bar(){
	        do {
	            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
	            let path = "\(documentDirectory)\(filename)"
	            let u = Department()
	            NSKeyedArchiver.archiveRootObject(u, toFile: path)
	            let user1 = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? Department
	            print(user1)
	        }catch {print("\(error)")}
	    }
	}

在控制台上期望输出的是：

	Optional(dept:{name:D1,tasks:Optional([{title:A1}, {title:A2}, {title:A3}]))




