//
//  app.swift
//  helloapp
//
//  Created by lcj on 2017/2/17.
//  Copyright © 2017年 liu. All rights reserved.
//

//
//  AppDelegate.swift
//  dou2
//
//  Created by quota on 12/21/15.
//  Copyright © 2015 liu. All rights reserved.
//

import UIKit
import AVFoundation

var player: AVAudioPlayer?

func playSound() {
    let url = Bundle.main.url(forResource: "a-sound2", withExtension: "mp3")!
    
    do {
        player = try AVAudioPlayer(contentsOf: url)
        guard let player = player else { return }
        
        player.prepareToPlay()
        player.play()
    } catch let error {
        print(error.localizedDescription)
    }
}
class Page1: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button   = UIButton(type: UIButtonType.system) as UIButton
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
        button.backgroundColor = UIColor.red
        button.setTitle("Test Button", for: UIControlState())
        button.addTarget(self, action: #selector(Page1.buttonAction(_:)), for: UIControlEvents.touchUpInside)
        view.addSubview(button)
        let button1   = UIButton(type: UIButtonType.system) as UIButton
        button1.frame = CGRect(x: 100, y: 300, width: 100, height: 50)
        button1.backgroundColor = UIColor.red
        button1.setTitle("θ", for: UIControlState())
        button1.addTarget(self, action: #selector(Page1.buttonAction1(_:)), for: UIControlEvents.touchUpInside)
        view.addSubview(button1)
    }
    func buttonAction(_ sender:UIButton!){
        print("button clicked")
        let nav1 = UINavigationController()
        //        var mainView = mainStoryboard.instantiateViewControllerWithIdentifier("Page2") as? Page2
        let mainView = Page2(nibName: nil, bundle: nil)
        nav1.viewControllers = [mainView]
        nav1.title = "Page2"
        nav1.modalPresentationStyle = .formSheet
        present(nav1, animated: true, completion: nil)
    }
    func buttonAction1(_ sender:UIButton!){
        print("button1 clicked")
        playSound()
    }
    func buttonAction4(_ sender:UIButton!){
        let nav1 = UINavigationController()
        let mainView = Page4(nibName: nil, bundle: nil)
        nav1.viewControllers = [mainView]
        nav1.title = "Page4"
        nav1.modalPresentationStyle = .formSheet
        present(nav1, animated: true, completion: nil)
    }
    func buttonAction5(_ sender:UIButton!){
        let nav1 = UINavigationController()
        let mainView = Page5(nibName: nil, bundle: nil)
        nav1.viewControllers = [mainView]
        nav1.title = "Page5"
        nav1.modalPresentationStyle = .formSheet
        present(nav1, animated: true, completion: nil)
    }
    func buttonAction6(_ sender:UIButton!){
        //        let nav1 = UINavigationController()
        let mainView = Page6(nibName: nil, bundle: nil)
        //        nav1.viewControllers = [mainView]
        //        nav1.title = "Page5"
        //        nav1.modalPresentationStyle = .FormSheet
        present(mainView, animated: true, completion: nil)
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
        let button   = UIButton(type: UIButtonType.system) as UIButton
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
        button.backgroundColor = UIColor.green
        button.setTitle("Test Button", for: UIControlState())
        button.addTarget(self, action: #selector(Page1.buttonAction(_:)), for: UIControlEvents.touchUpInside)
        view.addSubview(button)
    }
    func buttonAction(_ sender:UIButton!){
        print("button clicked")
        dismiss(animated: true, completion: nil)
    }
    
    func goBack(){
        dismiss(animated: true, completion: nil)
        
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
    class func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 10.0,height: 10.0 )
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

class Page3: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "section"
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let MyIdentifier = "MyReuseIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: MyIdentifier)
        if cell == nil {
            cell = UITableViewCell(style:UITableViewCellStyle.value1 , reuseIdentifier:MyIdentifier);
        }
        cell!.textLabel!.text = "text"
        cell!.detailTextLabel!.text = "detail"
        cell!.imageView!.image = UIImage.imageWithColor(UIColor.red)
        return cell!;
        
    }
    
    func goBack(){
        dismiss(animated: true, completion: nil)
        
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
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "section"
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let MyIdentifier = "MyReuseIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: MyIdentifier)
        var mainLabel : UILabel
        if cell == nil {
            cell = UITableViewCell(style:UITableViewCellStyle.default , reuseIdentifier:MyIdentifier);
            mainLabel = UILabel(frame:CGRect(x: 0.0, y: 0.0, width: 220.0, height: 15.0))
            mainLabel.tag = MAINLABEL_TAG;
            mainLabel.textAlignment = .left
            mainLabel.textColor = UIColor.black
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
        mainLabel = UILabel(frame:CGRect(x: 0.0, y: 0.0, width: 220.0, height: 15.0))
        mainLabel!.tag = MAINLABEL_TAG;
        mainLabel!.textAlignment = .left
        mainLabel!.textColor = UIColor.black
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
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "section"
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let MyIdentifier = "MyCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: MyIdentifier)
        if (cell == nil){
            cell = MyCell(style: .default, reuseIdentifier: MyIdentifier)
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
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "section"
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let MyIdentifier = "MyCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: MyIdentifier)
        if (cell == nil){
            cell = MyCell(style: .default, reuseIdentifier: MyIdentifier)
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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let nav1 = UINavigationController()
        let page1 = Page1(nibName: nil, bundle: nil)
        nav1.viewControllers = [page1]
        nav1.title = "Page1"
        
        self.window!.rootViewController = page1
        self.window?.makeKeyAndVisible()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

