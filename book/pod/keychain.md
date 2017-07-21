KeyChain提供了加密存储敏感信息的方法。所谓的敏感信息，不外是密码，信用卡号等。如果一个对象含有敏感信息，也可以把整个对象序列化为Data，然后整体存入KeyChain。对应的，也有从KeyChain中提取Data出来的操作。

然而，KeyChain默认提供的API是相当冗长和啰嗦的。而使用一些第三方库如KeyChainSwift又显得过于重量级。这里对KeyChain做了一个简单的封装，并提供了一个案例，可以把一个对象（User）存储到KeyChain内，并反向操作打印进入和出来的对象的结果。

对象是需要符合NSCoding协议的，以便可以序列化为Data对象，以及从Data对象内回复一个对象出来。代码改编于 https://gist.github.com/s-aska/e7ad24175fb7b04f78e7 

    import UIKit
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        var window: UIWindow?
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            let user = User(1,"tom")
            user.saveToKC()
            let user1 = User.loadFromKC()
            print(user,user1)
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
        func saveToKC(){
            let data = NSKeyedArchiver.archivedData(withRootObject: self)
            _ = Keychain.save(key: "user", data: data)
        }
        class func loadFromKC()-> User{
            let data = Keychain.load(key: "user")
            return  NSKeyedUnarchiver.unarchiveObject(with: data!) as! User
        }
    }
    import UIKit
    import Security
    class Keychain {
        class func save(key: String, data: Data) -> Bool {
            let query = [
                kSecClass as String       : kSecClassGenericPassword as String,
                kSecAttrAccount as String : key,
                kSecValueData as String   : data ] as [String : Any]
            SecItemDelete(query as CFDictionary)
            let status: OSStatus = SecItemAdd(query as CFDictionary, nil)
            return status == noErr
        }
        class func load(key: String) -> Data? {
            let query = [
                kSecClass as String       : kSecClassGenericPassword,
                kSecAttrAccount as String : key,
                kSecReturnData as String  : kCFBooleanTrue,
                kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]
            var dataTypeRef: AnyObject?
            let status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
            
            if status == errSecSuccess {
                if let data = dataTypeRef as! Data? {
                    return data
                }
            }
            return nil
        }
        class func delete(key: String) -> Bool {
            let query = [
                kSecClass as String       : kSecClassGenericPassword,
                kSecAttrAccount as String : key ] as [String : Any]
            
            let status: OSStatus = SecItemDelete(query as CFDictionary)
            return status == noErr
        }
        class func clear() -> Bool {
            let query = [ kSecClass as String : kSecClassGenericPassword ]
            let status: OSStatus = SecItemDelete(query as CFDictionary)
            return status == noErr
        }
    }
运行后，应该可以看到控制台上打印：
    
    {id:1,name:tom} {id:1,name:tom}