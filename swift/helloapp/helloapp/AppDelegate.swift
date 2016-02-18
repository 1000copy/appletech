//
//  AppDelegate.swift
//  helloapp
//
//  Created by quota on 2/18/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit


class ViewController1: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.greenColor()
        let button = UIButton()
        button.setTitle("transit", forState: .Normal)
        button.frame = CGRectMake(20, 20, 100,20)
        button.addTarget(self, action: "click:", forControlEvents: .TouchDown)
        view.addSubview(button)
    }
    func click(sender:UIButton!){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let window = appDelegate.window {
//            let v2 = ViewController2()
            
            if let r = window.rootViewController{
                r.transitionFromViewController(
                    appDelegate.v1!
                    ,toViewController:appDelegate.v2!,duration:0.8,options: .TransitionFlipFromLeft,animations:nil){_ in }
            }
        }
    }
    
}


class ViewController2: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blueColor()
    }
    override func viewWillAppear(animated: Bool) {
        print(animated)
    }

}

class ViewController3: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.redColor()
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var v1 : ViewController1?
    var v2 : ViewController2?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = ViewController3()
        v1 = ViewController1()
        v2 = ViewController2()
        v1!.view.frame = self.window!.frame
        self.window!.rootViewController?.addChildViewController(v1!)
        self.window!.rootViewController?.view.addSubview(v1!.view)
        self.window!.rootViewController?.addChildViewController(v2!)
        
        self.window?.makeKeyAndVisible()
        return true
    }
}

