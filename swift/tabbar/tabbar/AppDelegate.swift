//
//  AppDelegate.swift
//  tabbar
//
//  Created by quota on 1/31/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

class Item1ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let b = UIButton()
        b.frame = CGRectMake(10,200,100,100)
        b.setTitle("1", forState: .Normal)
                b.backgroundColor = UIColor.redColor()
        self.view.addSubview(b)
    }
}

class Item2ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let  b = UIButton()
        b.frame = CGRectMake(10,200,100,100)
        b.backgroundColor = UIColor.redColor()
        b.setTitle("2", forState: .Normal)
        self.view.addSubview(b)
    }
}

class Tabbar: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        let item1 = Item1ViewController()
//        let icon1 =
        item1.tabBarItem = UITabBarItem(title: "Title1",
            image: UIImage.imageWithColor(UIColor.yellowColor()) ,
            selectedImage: UIImage.imageWithColor(UIColor.yellowColor()) )
        let item2 = Item2ViewController()
        item2.tabBarItem = UITabBarItem(title: "Title2",
            image: UIImage.imageWithColor(UIColor.yellowColor()) ,
            selectedImage: UIImage.imageWithColor(UIColor.yellowColor()) )
        let controllers = [item1,item2]
        self.viewControllers = controllers
    }
    
    //Delegate methods
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        print("Should select viewController: \(viewController.title) ?")
        return true;
    }
}
extension UIImage {
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, 10.0,10.0 )
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
//        self.window!.rootViewController = ViewController()
        self.window!.rootViewController = Tabbar()
        self.window!.rootViewController!.view.backgroundColor = UIColor.whiteColor()
        self.window?.makeKeyAndVisible()
        return true
    }

  

}

