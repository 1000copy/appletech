//
//  AppDelegate.swift
//  dou2
//
//  Created by quota on 12/21/15.
//  Copyright © 2015 liu. All rights reserved.
//

import UIKit



@UIApplicationMain
class App: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var cellValue = [CellValue]()
    static var Delegate:App{
      return UIApplication.sharedApplication().delegate as! App
    }
    var nav :Nav?
    var list : PageTodo?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        nav = Nav()
        self.window!.rootViewController = nav
        self.window?.makeKeyAndVisible()
        cellValue+=[CellValue(t1:"1",t4: true)]
        cellValue+=[CellValue(t1:"2",t4: false)]
        cellValue+=[CellValue(t1:"3",t4: false)]
        list = nav?.viewControllers[0] as? PageTodo
        return true
    }
}

