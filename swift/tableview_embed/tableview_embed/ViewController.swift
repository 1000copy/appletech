//
//  ViewController.swift
//  tableview_embed
//
//  Created by quota on 2/1/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit
// 通过 UIView: 需要自己设置实现协议UITableViewDataSource，设置 dataSource
class ViewController1: UIViewController ,UITableViewDataSource{
    override func viewDidLoad() {
        super.viewDidLoad()
        let a  = UITableView()
        a.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        a.frame = CGRectMake(0,100,200,150)
        self.view.addSubview(a)
        self.view.backgroundColor = UIColor.redColor()
        a.dataSource = self
//        self.addChildViewController(a)
//        self.didMoveToParentViewController(a)
    }
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let MyIdentifier = "cell"
        var a = tableView.dequeueReusableCellWithIdentifier(MyIdentifier)
        if (a == nil){
            a = UITableViewCell(style: .Default, reuseIdentifier: MyIdentifier)
        }
        a!.backgroundColor = UIColor.greenColor()
        a!.textLabel?.text = "1"
        a!.detailTextLabel?.text = "1"
        return a!
    }

    
}
// 通过 ViewController ： 
// UITableViewController，代码规整，两个VC分工合理，且不需要设置 dataSource，不必conforms to UITableViewDataSource
// 因为UITableViewController已经做了。

class mtb1 : UITableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let MyIdentifier = "cell"
        var a = tableView.dequeueReusableCellWithIdentifier(MyIdentifier)
        if (a == nil){
            a = UITableViewCell(style: .Default, reuseIdentifier: MyIdentifier)
        }
        //        let a =  UITableViewCell()
        a!.backgroundColor = UIColor.greenColor()
        a!.textLabel?.text = "1"
        a!.detailTextLabel?.text = "1"
        return a!
    }
}
class ViewController: UIViewController {
    var  a : UITableViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        let a  = mtb1()
        a.view.frame = CGRectMake(0,100,300,200)
        self.view.addSubview(a.view)
        self.view.backgroundColor = UIColor.redColor()
    }
}

