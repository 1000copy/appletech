//
//  AppDelegate.swift
//  dou2
//
//  Created by quota on 12/21/15.
//  Copyright © 2015 liu. All rights reserved.
//

import UIKit

// Naviagtion Back> button
let MAINLABEL_TAG  = 1
class MyCell : UITableViewCell{
    var mainLabel : UILabel?
        var mainLabel1 : UILabel?
        var mainLabel2 : UILabel?
    var image1 : UIImageView?
    required override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style,reuseIdentifier: reuseIdentifier)

        f2()
    }
    func f1(){
        mainLabel = UILabel(frame:CGRectMake(0.0, 0.0, 220.0, 15.0))
        mainLabel1 = UILabel(frame:CGRectMake(0.0, 20.0, 220.0, 15.0))
        mainLabel2 = UILabel(frame:CGRectMake(0.0, 40.0, 220.0, 15.0))
        mainLabel!.tag = MAINLABEL_TAG;
        mainLabel!.textAlignment = .Left
        mainLabel!.textColor = UIColor.blackColor()
        self.contentView.addSubview(mainLabel!)
        mainLabel1!.tag = MAINLABEL_TAG;
        mainLabel1!.textAlignment = .Left
        mainLabel1!.textColor = UIColor.blackColor()
        self.contentView.addSubview(mainLabel1!)
        mainLabel2!.tag = MAINLABEL_TAG;
        mainLabel2!.textAlignment = .Left
        mainLabel2!.textColor = UIColor.blackColor()
        self.contentView.addSubview(mainLabel2!)
        image1 = UIImageView(frame:CGRectMake(0.0, 60.0, 220.0, 15.0))
        self.contentView.addSubview(image1!)
    }
    func f2(){
        mainLabel = UILabel()
        mainLabel1 = UILabel()
        mainLabel2 = UILabel()
        image1 = UIImageView()
        self.contentView.addSubview(mainLabel!)
        self.contentView.addSubview(mainLabel1!)
        self.contentView.addSubview(mainLabel2!)
        self.contentView.addSubview(image1!)
        
        mainLabel!.translatesAutoresizingMaskIntoConstraints = false
        mainLabel1!.translatesAutoresizingMaskIntoConstraints = false
        mainLabel2!.translatesAutoresizingMaskIntoConstraints = false
        image1?.translatesAutoresizingMaskIntoConstraints = false
        let h1 = NSLayoutConstraint(item: mainLabel!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 5)
        self.addConstraint(h1)
        
        let v1 = NSLayoutConstraint(item: mainLabel!, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 5)
        self.addConstraint(v1)

        let h2 = NSLayoutConstraint(item: mainLabel1!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:mainLabel!, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 5)
        self.addConstraint(h2)
        
        let v2 = NSLayoutConstraint(item: mainLabel1!, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 5)
        self.addConstraint(v2)
        
        let h3 = NSLayoutConstraint(item: mainLabel2!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:mainLabel1!, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 5)
        self.addConstraint(h3)
        
        let v3 = NSLayoutConstraint(item: mainLabel2!, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 5)
        self.addConstraint(v3)
        
        
        let h4 = NSLayoutConstraint(item: image1!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:mainLabel1!, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 5)
        self.addConstraint(h4)
        
        let v4 = NSLayoutConstraint(item: image1!, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 100)
        self.addConstraint(v4)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
}
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
                let p2 = Page7(nibName: nil, bundle: nil)
//        let p2 = Page7(coder: NSCoder())!
        self.navigationController?.pushViewController(p2, animated: true)
        //        navigationController?.navigationBar.topItem?.title = "page 2"
    }
    
}
class AObj : NSObject{
    var t1 : String?
    var t2 : String?
    var t3 : String?
    var image : UIImage?
    init(_ t1:String,_ t2:String ,_ t3:String,_ image : UIImage){
        self.t1 = t1
        self.t2 = t2
        self.t3 = t3
        self.image = image
    }
//    override func init(){
//        self.t1 = "t1"
//        self.t2 = "t2"
//        self.t3 = "t3"
//    }
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

class Page7: UITableViewController {
    var texts = [AObj]()
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
//        super.init(nibName:nibNameOrNil,bundle:nibBundleOrNil)
//    }
    func loadData(){
        texts = [AObj]()
        let t1 = AObj( "1","2","3",UIImage.imageWithColor(UIColor.redColor()))
        let t2 = AObj("1","2","3",UIImage.imageWithColor(UIColor.yellowColor()))
        let t3 = AObj("1","2","3",UIImage.imageWithColor(UIColor.blueColor()))
        texts += [t1,t2,t3]
//        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return texts.count
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let MyIdentifier = "MyCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(MyIdentifier)
        if (cell == nil){
            cell = MyCell(style: .Default, reuseIdentifier: MyIdentifier)
        }
        (cell as! MyCell).mainLabel?.text = texts[indexPath.row].t1
        (cell as! MyCell).mainLabel1?.text = texts[indexPath.row].t2
        (cell as! MyCell).mainLabel2?.text = texts[indexPath.row].t3
        (cell as! MyCell).image1?.image = texts[indexPath.row].image
        return cell!;
        
    }
}
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
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
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
        (cell as! MyCell).mainLabel1?.text = "text2"
        (cell as! MyCell).mainLabel2?.text = "text3"
        return cell!;
        
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

class Page3 : UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        let newView = UIView()
        newView.backgroundColor = UIColor.redColor()
        newView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newView)
        
        let views = ["view": view, "newView": newView]
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[view]-(<=0)-[newView(100)]", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: views)
        view.addConstraints(horizontalConstraints)
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[view]-(<=0)-[newView(100)]", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: views)
        view.addConstraints(verticalConstraints)
    }
}
class Page4 : UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newView = UIView()
        newView.backgroundColor = UIColor.redColor()
        newView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newView)
        
        let horizontalConstraint = NSLayoutConstraint(item: newView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        view.addConstraint(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint(item: newView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        view.addConstraint(verticalConstraint)
        
        let widthConstraint = NSLayoutConstraint(item: newView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
        view.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: newView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
        view.addConstraint(heightConstraint)
    }
}

class Red : UIView{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

}
class Page5 : UIViewController{
    var mainView:UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = UIView()
        vvv(mainView!)
        let v = UIView()
        v3(v)
    }
    func vvv(v1:UIView){
        v1.backgroundColor = UIColor.yellowColor()
        v1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(v1)
        let horizontalConstraint = NSLayoutConstraint(item: v1, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 5)
        view.addConstraint(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint(item: v1, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 100)
        view.addConstraint(verticalConstraint)
        
        let widthConstraint = NSLayoutConstraint(item: v1, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
        view.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: v1, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
        view.addConstraint(heightConstraint)
    }
    func v3(v1:UIView){
        v1.backgroundColor = UIColor.redColor()
        v1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(v1)
        let horizontalConstraint = NSLayoutConstraint(item: v1, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: mainView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 5)
        view.addConstraint(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint(item: v1, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 100)
        view.addConstraint(verticalConstraint)
        
        let widthConstraint = NSLayoutConstraint(item: v1, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
        view.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: v1, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
        view.addConstraint(heightConstraint)
    }

}

class RedBlock : UIView{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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

