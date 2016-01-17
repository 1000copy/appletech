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
    var todos = [Todo]()
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
        todos+=[Todo(info:"1",checked: true)]
        todos+=[Todo(info:"2",checked: false)]
        todos+=[Todo(info:"3",checked: false)]
        list = nav?.viewControllers[0] as? PageTodo
        return true
    }
}

