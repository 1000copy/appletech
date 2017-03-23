创建一个Single View App之后

## 访问sqlite的C语言库

需要一些令人厌倦的操作的过程


1、点击项目名称 - Linked Frameworks and Libraries - “+” - 搜索“libsqlite3.dylib” - 然后点击Add
2. 添加桥接文件

访问SQLite数据库需要使用SQLite官方提供的C语言风格的API，所以需要添加桥接文件。过程为：

		右击项目名称 - New File… - Header File - 命名为“SQLite-Bridge.h”，

并在“SQLite-Bridge.h”这个头文件中加一行代码

		#import "sqlite3.h"
3. 告诉Xcode此桥接文件的名字

首先定位到修改点，操作过程为：

		点击项目名称 - Build Settings - 点击All - 点击Combined - 搜索“bridging” - 单击“Objective-C Bridging Header” - 

双击后面后弹出添加文件名，把刚刚创建的头文件名称写进去- 然后回车

4. 编译。如果通过，此过程就算完成。

之前曾经写错了文件名，写成了#import "sqlite.h"，懊恼很久。

## 一键运行代码

        import UIKit
        @UIApplicationMain
        class AppDelegate: UIResponder, UIApplicationDelegate {
            var window : UIWindow?
            func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
                window = UIWindow()
                window!.rootViewController = UIViewController()
                window!.rootViewController!.view.backgroundColor = .blue
                window!.makeKeyAndVisible()
                print("创建数据库")
                SQLManager.shareInstance().createDataBaseTableIfNeeded()
                print("已执行")
                foo()
                return true
            }
            func foo(){
              bar()
              baz()
            }
        }
        
        //
        //  SQLManager.swift
        //  demo11_SQLiteWithSwift
        //
        //  Created by ChenXin on 2016/12/2.
        //  Copyright © 2016年 ChenXin. All rights reserved.
        //
        
        
        
        let DBFILE_NAME = "Student.sqlite"
        
        public class SQLManager : NSObject {
            // 创建该类的静态实例变量
            static let instance = SQLManager();
            // 定义数据库变量
            var db : OpaquePointer? = nil
            // 对外提供创建单例对象的接口
            class func shareInstance() -> SQLManager {
                return instance
            }
            
            // 获取数据库文件的路径
            func getFilePath() -> String {
                let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
                let DBPath = (documentPath! as NSString).appendingPathComponent(DBFILE_NAME)
                print("数据库的地址是：\(DBPath)")
                return DBPath
            }
            
            func createDataBaseTableIfNeeded() {
                // 只接受C语言的字符串，所以要把DBPath这个NSString类型的转换为cString类型，用UTF8的形式表示
                let cDBPath = getFilePath().cString(using: String.Encoding.utf8)
                
                // 第一个参数：数据库文件路径，这里是我们定义的cDBPath
                // 第二个参数：数据库对象，这里是我们定义的db
                // SQLITE_OK是SQLite内定义的宏，表示成功打开数据库
                if sqlite3_open(cDBPath, &db) != SQLITE_OK {
                    // 失败
                    print("数据库打开失败~！")
                } else {
                    // 创建表的SQL语句（根据自己定义的数据model灵活改动）
                    print("数据库打开成功~！")
                    let createStudentTableSQL = "CREATE TABLE IF NOT EXISTS 't_Student' ('stuNum' integer NOT NULL PRIMARY KEY AUTOINCREMENT, 'stuName' TEXT);"
                    if execSQL(SQL: createStudentTableSQL) == false {
                        // 失败
                        print("执行创建表的SQL语句出错~")
                    } else {
                        print("创建表的SQL语句执行成功！")
                    }
                }
            }
            
            // 查询数据库，传入SQL查询语句，返回一个字典数组
            func queryDataBase(querySQL : String) -> [[String : AnyObject]]? {
                // 创建一个语句对象
                var statement : OpaquePointer? = nil
                
                if querySQL.lengthOfBytes(using: String.Encoding.utf8) > 0 {
                    let cQuerySQL = (querySQL.cString(using: String.Encoding.utf8))!
                    // 进行查询前的准备工作
                    // 第一个参数：数据库对象，第二个参数：查询语句，第三个参数：查询语句的长度（如果是全部的话就写-1），第四个参数是：句柄（游标对象）
                    if sqlite3_prepare_v2(db, cQuerySQL, -1, &statement, nil) == SQLITE_OK {
                        var queryDataArr = [[String: AnyObject]]()
                        while sqlite3_step(statement) == SQLITE_ROW {
                            // 获取解析到的列
                            let columnCount = sqlite3_column_count(statement)
                            // 遍历某行数据
                            var temp = [String : AnyObject]()
                            for i in 0..<columnCount {
                                // 取出i位置列的字段名,作为temp的键key
                                let cKey = sqlite3_column_name(statement, i)
                                let key : String = String(validatingUTF8: cKey!)!
                                //取出i位置存储的值,作为字典的值value
                                let cValue = sqlite3_column_text(statement, i)
                                let value = String(cString: cValue!)
                                temp[key] = value as AnyObject
                            }
                            queryDataArr.append(temp)
                        }
                        return queryDataArr
                    }
                }
                return nil
            }
            
            // 执行SQL语句的方法，传入SQL语句执行
            func execSQL(SQL : String) -> Bool {
                let cSQL = SQL.cString(using: String.Encoding.utf8)
                let errmsg : UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>? = nil
                if sqlite3_exec(db, cSQL, nil, nil, errmsg) == SQLITE_OK {
                    return true
                } else {
                        let errmsg2=String.init(validatingUTF8: sqlite3_errmsg(db));
//                    let errmsg1=String.fromCString(sqlite3_errmsg(db));
                    print("执行SQL语句时出错，错误信息为：\(errmsg2)")
                    return false
                }
            }   
        }
        class StudentModel: NSObject {
            var idNum : String = ""
            var stuName : String = ""
            
            init(idNum : String, stuName : String) {
                self.idNum = idNum
                self.stuName = stuName
            }
            
            override init() {
                super.init()
            }
            override public var description: String { return "\(idNum),\(stuName)" }
        }
        func bar() {
            // 写入数据库的操作代码
            
            let stuNameText = "liuchuo"
            let insertSQL = "INSERT INTO 't_Student' (stuName) VALUES ( '\(stuNameText)');"
            if SQLManager.shareInstance().execSQL(SQL: insertSQL) == true {
                print("插入数据add成功")
            }
            
        }
        func baz() {
            let querySQL = "SELECT stuNum, stuName FROM 't_Student';"
            // 取出查询到的结果
            let resultDataArr = SQLManager.shareInstance().queryDataBase(querySQL: querySQL)
            var stuArr = [StudentModel()]
            for dict in (resultDataArr)! {
                let mymodel = StudentModel(idNum: dict["stuNum"] as! String, stuName: dict["stuName"] as! String)
                stuArr.append(mymodel)
                
            }
            print(stuArr)
        }
