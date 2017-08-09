典型的前台后台的交互操作，几乎都是这样的：
1. 访问后台服务API
2. 然后解析它返回的JSON

使用Alamofire，它的扩展AlamofireObjectMapper可以把HTTP访问获得的结果转换为json对象，使用ObjectMapper可以把json对象和swift对象做一个映射。

如下案例，访问cnodejs.org提供的API，并转换返回json为swift对象，并且打印验证：

    import UIKit
    import Alamofire
    import AlamofireObjectMapper
    import ObjectMapper
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate,URLSessionDelegate {
        var window: UIWindow?
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            foo()
            return true
        }
        func foo(){
            let URL = "https://cnodejs.org/api/v1/topics?page=2"
            Alamofire.request(URL).responseObject { (response: DataResponse<Topics>) in
                
                let topics = response.result.value
                print(topics?.success)
                print(topics?.data?.count)
                if let item = topics?.data {
                    for it in item {
                        print(it.id)
                        print(it.author?.avatar_url)
                        print(it.tab)
                        return
                    }
                }
            }
        }
    }
    class Topics: Mappable {
        var success: Bool?
        var data : [Topic]?
        required init?(map: Map){
            
        }
        
        func mapping(map: Map) {
            success <- map["success"]
            data <- map["data"]
        }
    }
    //content title last_reply_at good top reply_count visit_count create_at author{loginname,avatar_url}
    class Author : Mappable{
        var loginname: String?
        var avatar_url: String?
        required init?(map: Map){
            
        }
        func mapping(map: Map) {
            loginname <- map["loginname"]
            avatar_url <- map["avatar_url"]
        }
    }
    class Topic: Mappable {
        var id: String?
        var author_id : String?
        var tab : String?
        var content : String?
        var title : String?
        var last_reply_at : String?
        var good : String?
        var top : String?
        var reply_count : String?
        var visit_count : String?
        var create_at : String?
        var author : Author?
        required init?(map: Map){
            
        }
        func mapping(map: Map) {
            id <- map["id"]
            author_id <- map["author_id"]
            content <- map["content"]
            title <- map["title"]
            last_reply_at <- map["last_reply_at"]
            good <- map["good"]
            top <- map["top"]
            reply_count <- map["reply_count"]
            visit_count <- map["visit_count"]
            create_at <- map["create_at"]
            author <- map["author"]
            tab <- map["tab"]
        }
    }

如果打印结果形如：

    Optional(true)
    Optional(40)
    Optional("5989cd6c2d4b0af475035399")
    Optional("59603478a4de5625080fe1cd")
    Optional("ask")
说明代码正常运作。