# 访问sqlite

可以使用sqlite作为关系数据库来存储iOS本地数据。这意味着，通过sql语言方便的做数据的增删改查。

sqlite本身提供了C语言的API，使用Swift访问需要
1. 创建一个桥接文件，引入C API，访问SQLite数据库需要使用SQLite官方提供的C语言风格的API，所以需要添加桥接文件
2. 引入sqlite的动态链接库

首先我们让Swift到Sqlite的道路打通。

## 访问sqlite的C语言库

创建一个Single View App之后，需要一些令人厌倦的操作的过程

1、点击项目名称 - 查看General页面 -  Linked Frameworks and Libraries - “+” - 搜索“libsqlite3.dylib” - 然后点击Add
2. 新建一个头文件，命名为SQLite-Bridge.h。具体过程为：

		右击项目名称 - New File… - Header File - 命名为“SQLite-Bridge.h”，

并在这个头文件中加一行代码

		#import "sqlite3.h"

注意，此处包含的头文件，是sqlite3.h，而不是sqlite.h。

3. 把此头文件设置为桥接文件。首先定位到修改点，操作过程为：

		点击项目名称 - Build Settings - 点击All - 点击Combined - 单击“Objective-C Bridging Header”（可以通过搜索“bridging”快速定位此配置项） -  双击后面后弹出添加文件名，把刚刚创建的头文件名称写进去- 然后回车

4. 编译。如果编译通过，那么Swift到sqlite的链接过程就算对了。

## 一个sqlite访问的封装和使用案例

为了方便让Swift App使用，做一个封装是必要的。封装代码可以让开发者只要使用此查询执行函数、而不必关心sqlite的C API的底层细节，就可以和数据库完成交互。如下案例，不仅包括封装于类Sqlite的代码，也包括使用此代码的使用方法。案例中创建了一个todo的表，并且在其中插入一条数据，然后做一个查询，打印查询出来的结果：


		import UIKit
        @UIApplicationMain
        class AppDelegate: UIResponder, UIApplicationDelegate {
            var window : UIWindow?
            func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
                window = UIWindow()
                window!.rootViewController = UIViewController()
                window!.rootViewController!.view.backgroundColor = .blue
                window!.makeKeyAndVisible()
                let dbname = "mysqlite"
                let db = Sqlite(dbname)
                if db.createDatabase(){
                    print("创建数据库 OK")
                }
                print(db.ExecuteQuery( "CREATE TABLE IF NOT EXISTS 'todo' ('id' integer NOT NULL PRIMARY KEY AUTOINCREMENT, 'item' TEXT);"))
                print(db.ExecuteQuery( "insert into todo(item)values('1');"))
                print(db.SelectQuery( "select * from todo;"))
                return true
            }
        }
        class Sqlite: NSObject
        {
            var dbname :String!
            var DBpath :String!
            init(_ dbname:String){
                super.init()
                self.dbname = dbname
                self.DBpath = self.databasePath()
            }
            func createDatabase()->Bool
            {
                var success:Bool=false
                print(DBpath)
                if (FileManager.default.fileExists(atPath: DBpath))
                {
                    success = true
                }
                else
                {
                    let pathfrom:String=(Bundle.main.resourcePath! as NSString).appendingPathComponent(dbname)
                    do {
                        try FileManager.default.copyItem(atPath: pathfrom, toPath: DBpath)
                        success = true
                    } catch _ {
                        success = false
                    }
                }
                return success
            }
            func databasePath() -> String
            {
                var path:Array=NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
                let directory=path[0]
                let DBpath=(directory as NSString).appendingPathComponent(dbname)
                return DBpath as String
            }
            func ExecuteQuery(_ str:String) -> Bool
            {
                var result:Bool=false
                var db: OpaquePointer? = nil
                var stmt:OpaquePointer? = nil
                let strExec=str.cString(using: String.Encoding.utf8)
                if (sqlite3_open(DBpath, &db)==SQLITE_OK)
                {
                    if (sqlite3_prepare_v2(db, strExec! , -1, &stmt, nil) == SQLITE_OK)
                    {
                        if (sqlite3_step(stmt) == SQLITE_DONE)
                        {
                            result=true
                        }
                    }
                    sqlite3_finalize(stmt)
                }
                sqlite3_close(db)
                return result
            }
            func SelectQuery(_ str:String) -> Array<Dictionary<String,String>>
            {
                var result:Array<Dictionary<String,String>>=[]
                var db: OpaquePointer? = nil
                var stmt:OpaquePointer? = nil
                let strExec=str.cString(using: String.Encoding.utf8)
                if ( sqlite3_open(DBpath,&db) == SQLITE_OK)
                {
                    if (sqlite3_prepare_v2(db, strExec! , -1, &stmt, nil) == SQLITE_OK)
                    {
                        while (sqlite3_step(stmt) == SQLITE_ROW)
                        {
                            var i:Int32=0
                            let icount:Int32=sqlite3_column_count(stmt)
                            var dict=Dictionary<String, String>()
                            while i < icount
                            {
                                let strF=sqlite3_column_name(stmt, i)
                                let strV = sqlite3_column_text(stmt, i)
                                let rFiled:String=String(cString: strF!)
                                let rValue:String=String(cString: strV!)
                                dict[rFiled] = rValue
                                i += 1
                            }
                            result.insert(dict, at: result.count)
                        }
                        sqlite3_finalize(stmt)
                    }
                    sqlite3_close(db)
                }
                return result
            }
        }

作为程序员，可以直接使用此类做数据库的访问，如果对sqlite内部C API的使用感兴趣，则可以进一步的阅读此类的实现部分。


