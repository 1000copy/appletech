//
//  ViewController.swift
//  tableview_embed
//
//  Created by quota on 2/1/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

class LangTableViewController : UITableViewController{
    let arr = ["swift","obj-c","ruby"]
    let MyIdentifier = "cell"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: MyIdentifier)
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let a = tableView.dequeueReusableCellWithIdentifier(MyIdentifier)
        a!.textLabel?.text = arr[indexPath.row]
        return a!
    }
}
class ViewController: UIViewController {
    var  a : LangTableViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        let a  = LangTableViewController()
        a.view.frame = CGRectMake(0,100,300,100)
        self.view.addSubview(a.view)
        self.addChildViewController(a)
        
        let b  = LangTable()
        b.frame = CGRectMake(0,200,300,100)
        self.view.addSubview(b)
        
        let c  = LangTableWithDequeueReusableCellWithIdentifier()
        c.frame = CGRectMake(0,300,300,100)
        self.view.addSubview(c)
    }
}




class LangTable : UITableView,UITableViewDataSource{
    let arr = ["java"]
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame:frame,style:style)
        self.dataSource = self
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let a = UITableViewCell(style: .Default, reuseIdentifier: nil)
        a.textLabel?.text = String(arr[indexPath.row])
        return a
    }
}

class LangTableWithDequeueReusableCellWithIdentifier: UITableView,UITableViewDataSource{
    let arr = ["javascript","delphi"]
    let MyIdentifier = "cell"
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame:frame,style:style)
        self.dataSource = self
        self.registerClass(UITableViewCell.self, forCellReuseIdentifier: MyIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let a = tableView.dequeueReusableCellWithIdentifier(MyIdentifier)!
        a.textLabel?.text = String(arr[indexPath.row])
        return a
    }
}
