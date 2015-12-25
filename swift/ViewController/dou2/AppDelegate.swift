//
//  AppDelegate.swift
//  dou2
//
//  Created by quota on 12/21/15.
//  Copyright © 2015 liu. All rights reserved.
//

import UIKit

class Page1: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button   = UIButton(type: UIButtonType.System) as UIButton
        button.frame = CGRectMake(100, 100, 100, 50)
        button.backgroundColor = UIColor.redColor()
        button.setTitle("Test Button", forState: UIControlState.Normal)
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
        // button 2
        let button1   = UIButton(type: UIButtonType.System) as UIButton
        button1.frame = CGRectMake(100, 200, 100, 50)
        button1.backgroundColor = UIColor.blueColor()
        button1.setTitle("Test Button", forState: UIControlState.Normal)
        button1.addTarget(self, action: "buttonAction1:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button1)
    }
    func buttonAction(sender:UIButton!){
        print("button clicked")
        let nav1 = UINavigationController()
        //        var mainView = mainStoryboard.instantiateViewControllerWithIdentifier("Page2") as? Page2
        let mainView = Page2(nibName: nil, bundle: nil)
        nav1.viewControllers = [mainView]
        nav1.title = "Page2"
        nav1.modalPresentationStyle = .FormSheet
        presentViewController(nav1, animated: true, completion: nil)
    }
    func buttonAction1(sender:UIButton!){
        print("button1 clicked")
        let nav1 = UINavigationController()
        let mainView = Page3(nibName: nil, bundle: nil)
        nav1.viewControllers = [mainView]
        nav1.title = "Page3"
        nav1.modalPresentationStyle = .FormSheet
        presentViewController(nav1, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}


class Page2: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button   = UIButton(type: UIButtonType.System) as UIButton
        button.frame = CGRectMake(100, 100, 100, 50)
        button.backgroundColor = UIColor.greenColor()
        button.setTitle("Test Button", forState: UIControlState.Normal)
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button)
    }
    func buttonAction(sender:UIButton!){
        print("button clicked")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func goBack(){
        dismissViewControllerAnimated(true, completion: nil)
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
/*
There are many ways to put together a table view app. For example, you can use an instance of a custom NSObject subclass to create, configure, and manage a table view. However, you will find the task much easier if you adopt the classes, techniques, and design patterns that the UIKit framework offers for this purpose. The following approaches are recommended:

Use an instance of a subclass of UITableViewController to create and manage a table view.
Most apps use a custom UITableViewController object to manage a table view. As described in Navigating a Data Hierarchy with Table Views, UITableViewController automatically creates a table view, assigns itself as both delegate and data source (and adopts the corresponding protocols), and initiates the procedure for populating the table view with data. It also takes care of several other “housekeeping” details of behavior. The behavior of UITableViewController (a subclass of UIViewController) within the navigation controller architecture is described in Table View Controllers.
*/
class Page3: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "section"
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let MyIdentifier = "MyReuseIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(MyIdentifier)
        if cell == nil {
            cell = UITableViewCell(style:UITableViewCellStyle.Default , reuseIdentifier:MyIdentifier);
        }
        cell!.textLabel!.text = "1"
        return cell!;
        
    }
    
    func goBack(){
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

//    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
//    var nav1 = UINavigationController()
//    var mainView = ViewController(nibName: nil, bundle: nil) //ViewController = Name of your controller
//    nav1.viewControllers = [mainView]
//    self.window!.rootViewController = nav1
//    self.window?.makeKeyAndVisible()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        var nav1 = UINavigationController()
//        var mainView = mainStoryboard.instantiateViewControllerWithIdentifier("Page2") as? Page2
        var page1 = Page1(nibName: nil, bundle: nil)
        nav1.viewControllers = [page1]
        nav1.title = "Page1"

        self.window!.rootViewController = nav1
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

