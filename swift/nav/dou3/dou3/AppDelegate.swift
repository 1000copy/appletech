//
//  AppDelegate.swift
//  dou2
//
//  Created by quota on 12/21/15.
//  Copyright © 2015 liu. All rights reserved.
//

import UIKit

class CellTodo : UITableViewCell{
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

struct CellValue{
    var t1:String
    var t2:String
    var t3:String
}
class PageTodo: UITableViewController {
    var cellValue = [CellValue]()
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController!.navigationItem.rightBarButtonItem = editButtonItem()
        cellValue+=[CellValue(t1:"1",t2:"-",t3: "-")]
        cellValue+=[CellValue(t1:"2",t2:"-",t3: "-")]
        cellValue+=[CellValue(t1:"3",t2:"-",t3: "-")]
        navigationItem.rightBarButtonItem = editButtonItem()
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellValue.count
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let MyIdentifier = "MyCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(MyIdentifier)
        var c : CellTodo
        if (cell == nil){
            c = CellTodo(style: .Default, reuseIdentifier: MyIdentifier)
        }else{
            c = cell as! CellTodo
        }

        c.mainLabel?.text = cellValue[indexPath.row].t1
        c.mainLabel1?.text = cellValue[indexPath.row].t2
        c.mainLabel2?.text = cellValue[indexPath.row].t3
        return c;
        
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            cellValue.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
}

class Nav : UINavigationController{
    override func viewDidLoad() {
        super.viewDidLoad()
        let  p = PageTodo(nibName: nil, bundle: nil)
        //         navigationController?.navigationBar.topItem?.title = "page 1"
        viewControllers = [p]
        
    }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var data:String?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = Nav()
        self.window?.makeKeyAndVisible()
        data = "app delegate"
        return true
    }
}

