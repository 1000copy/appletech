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
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = Nav()
        self.window?.makeKeyAndVisible()
        cellValue+=[CellValue(t1:"1",t4: true)]
        cellValue+=[CellValue(t1:"2",t4: false)]
        cellValue+=[CellValue(t1:"3",t4: false)]
        return true
    }
}

