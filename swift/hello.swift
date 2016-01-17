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
        let button4   = UIButton(type: UIButtonType.System) as UIButton
        button4.frame = CGRectMake(100, 300, 100, 50)
        button4.backgroundColor = UIColor.blueColor()
        button4.setTitle("Button4", forState: UIControlState.Normal)
        button4.addTarget(self, action: "buttonAction4:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button4)
        let button5   = UIButton(type: UIButtonType.System) as UIButton
        button5.frame = CGRectMake(100, 350, 100, 50)
        button5.backgroundColor = UIColor.blueColor()
        button5.setTitle("Button5", forState: UIControlState.Normal)
        button5.addTarget(self, action: "buttonAction5:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button5)
        let button6   = UIButton(type: UIButtonType.System) as UIButton
        button6.frame = CGRectMake(100, 400, 100, 50)
        button6.backgroundColor = UIColor.blueColor()
        button6.setTitle("Button6", forState: UIControlState.Normal)
        button6.addTarget(self, action: "buttonAction6:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(button6)
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
    func buttonAction4(sender:UIButton!){
        let nav1 = UINavigationController()
        let mainView = Page4(nibName: nil, bundle: nil)
        nav1.viewControllers = [mainView]
        nav1.title = "Page4"
        nav1.modalPresentationStyle = .FormSheet
        presentViewController(nav1, animated: true, completion: nil)
    }
    func buttonAction5(sender:UIButton!){
        let nav1 = UINavigationController()
        let mainView = Page5(nibName: nil, bundle: nil)
        nav1.viewControllers = [mainView]
        nav1.title = "Page5"
        nav1.modalPresentationStyle = .FormSheet
        presentViewController(nav1, animated: true, completion: nil)
    }
    func buttonAction6(sender:UIButton!){
//        let nav1 = UINavigationController()
        let mainView = Page6(nibName: nil, bundle: nil)
//        nav1.viewControllers = [mainView]
//        nav1.title = "Page5"
//        nav1.modalPresentationStyle = .FormSheet
        presentViewController(mainView, animated: true, completion: nil)
//        mainView.modalPresentationStyle = .FullScreen
//        pushViewController(mainView,animated: true)
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
            cell = UITableViewCell(style:UITableViewCellStyle.Value1 , reuseIdentifier:MyIdentifier);
        }
        cell!.textLabel!.text = "text"
        cell!.detailTextLabel!.text = "detail"
        cell!.imageView!.image = UIImage.imageWithColor(UIColor.redColor())
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
//Adding subviews to a cell’s content view
let MAINLABEL_TAG = 1
class Page4: UITableViewController {
    
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
        var mainLabel : UILabel
        if cell == nil {
            cell = UITableViewCell(style:UITableViewCellStyle.Default , reuseIdentifier:MyIdentifier);
            mainLabel = UILabel(frame:CGRectMake(0.0, 0.0, 220.0, 15.0))
            mainLabel.tag = MAINLABEL_TAG;
            mainLabel.textAlignment = .Left
            mainLabel.textColor = UIColor.blackColor()
//            mainLabel.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin || UIViewAutoresizing.FlexibleHeight
            cell?.contentView.addSubview(mainLabel)
        }else{
            mainLabel = cell!.contentView.viewWithTag(MAINLABEL_TAG) as! UILabel
        }
        mainLabel.text = "text"
        return cell!;
        
    }
}

// Customize cell 

class MyCell : UITableViewCell{
    var mainLabel : UILabel?
    required override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style,reuseIdentifier: reuseIdentifier)
            mainLabel = UILabel(frame:CGRectMake(0.0, 0.0, 220.0, 15.0))
            mainLabel!.tag = MAINLABEL_TAG;
            mainLabel!.textAlignment = .Left
            mainLabel!.textColor = UIColor.blackColor()
            self.contentView.addSubview(mainLabel!)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
}
class Page5: UITableViewController {
    
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
        let MyIdentifier = "MyCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(MyIdentifier)
        if (cell == nil){
            cell = MyCell(style: .Default, reuseIdentifier: MyIdentifier)
        }
        (cell as! MyCell).mainLabel?.text = "text1"
        return cell!;
        
    }
}


// Naviagtion Back> button
class Page6: UITableViewController {
    
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
        let MyIdentifier = "MyCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(MyIdentifier)
        if (cell == nil){
            cell = MyCell(style: .Default, reuseIdentifier: MyIdentifier)
        }
        (cell as! MyCell).mainLabel?.text = "text1"
        return cell!;
        
    }
}



@UIApplicationMain

//self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//// Override point for customization after application launch.
//frstVwCntlr = [[firstViewController alloc] initWithNibName:@"firstViewController" bundle:nil];
//self.navController = [[UINavigationController alloc] initWithRootViewController:self.frstVwCntlr];
//self.window.rootViewController = self.navController;
//self.window.backgroundColor = [UIColor whiteColor];
//[self.window makeKeyAndVisible];


class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let nav1 = UINavigationController()
        let page1 = Page1(nibName: nil, bundle: nil)
        nav1.viewControllers = [page1]
        nav1.title = "Page1"

        self.window!.rootViewController = page1
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

