//
//  AppDelegate.swift
//  dou2
//
//  Created by quota on 12/21/15.
//  Copyright © 2015 liu. All rights reserved.
//

import UIKit

class Page1 : UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        let button   = UIButton(type: UIButtonType.System) as UIButton
        button.frame = CGRectMake(100, 100, 100, 50)
        button.backgroundColor = UIColor.redColor()
        button.setTitle("1", forState: UIControlState.Normal)
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
        self.navigationItem.title = "YourTitle"

    }
    func buttonAction(sender:UIButton!){
        let p2 = Page2(nibName: nil, bundle: nil)
        self.navigationController?.pushViewController(p2, animated: true)
//        navigationController?.navigationBar.topItem?.title = "page 2"
    }

}
class Page2 : UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        let button   = UIButton(type: UIButtonType.System) as UIButton
        button.frame = CGRectMake(100, 100, 100, 50)
        button.backgroundColor = UIColor.redColor()
        button.setTitle("2", forState: UIControlState.Normal)
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
//        navigationController?.navigationBar.topItem?.title = "page 2"
                self.navigationItem.title = "YourTitle2"
    }
    func buttonAction(sender:UIButton!){
        let alertController = UIAlertController(title: "Default Style", message: "A standard alert.", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            print(action.title)
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            print("2")
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
         
        }
    }
}

class Nav : UINavigationController{
    override func viewDidLoad() {
        super.viewDidLoad()
        let  p1 = Page1(nibName: nil, bundle: nil)
//         navigationController?.navigationBar.topItem?.title = "page 1"
        viewControllers = [p1]

    }
}

@UIApplicationMain



class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = Nav()
        self.window?.makeKeyAndVisible()
        return true
    }
}

