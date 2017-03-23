//
//  ViewController.swift
//  sqlite
//
//  Created by lcj on 2017/3/22.
//  Copyright © 2017年 lcj. All rights reserved.
//

import UIKit
import SQLite
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        abc()
    }
    func abc(){
        do{
            let db = try Connection("mydb1.sqlite")
            
//            let users = Table("users")
//            let id = Expression<Int64>("id")
//            let name = Expression<String?>("name")
//            let email = Expression<String>("email")
//            
//            try db.run(users.create { t in
//                t.column(id, primaryKey: true)
//                t.column(name)
//                t.column(email, unique: true)
//            })
////             CREATE TABLE "users" (
////                 "id" INTEGER PRIMARY KEY NOT NULL,
////                 "name" TEXT,
////                 "email" TEXT NOT NULL UNIQUE
////             )
//            
//            let insert = users.insert(name <- "Alice", email <- "alice@mac.com")
//            let rowid = try db.run(insert)
//            // INSERT INTO "users" ("name", "email") VALUES ('Alice', 'alice@mac.com')
//            
//            for user in try db.prepare(users) {
//                print("id: \(user[id]), name: \(user[name]), email: \(user[email])")
//                // id: 1, name: Optional("Alice"), email: alice@mac.com
//            }
//            // SELECT * FROM "users"
//            
//            let alice = users.filter(id == rowid)
//            
//            try db.run(alice.update(email <- email.replace("mac.com", with: "me.com")))
//            // UPDATE "users" SET "email" = replace("email", 'mac.com', 'me.com')
//            // WHERE ("id" = 1)
//            
//            try db.run(alice.delete())
//            // DELETE FROM "users" WHERE ("id" = 1)
            
//            try print(db.scalar(users.count) // 0
            // SELECT count(*) FROM "users" SQLite.swift also works as a lightweight, Swift-friendly wrapper over the C API.
            
//            let stmt = try db.prepare("INSERT INTO users (email) VALUES (?)")
//            for email in ["betty@icloud.com", "cathy@icloud.com"] {
//                try stmt.run(email)
//            }
            
            //        db.totalChanges    // 3
            //        db.changes         // 1
            //        db.lastInsertRowid // 3
            //
            for row in try db.prepare("SELECT id, email FROM users") {
                print("id: \(row[0]), email: \(row[1])")
                // id: Optional(2), email: Optional("betty@icloud.com")
                // id: Optional(3), email: Optional("cathy@icloud.com")
            }
            
            try print(db.scalar("SELECT count(*) FROM users")) // 2
        }catch{
            print("some \(error)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.rootViewController = ViewController()
        self.window?.makeKeyAndVisible()
        return true
    }
}

