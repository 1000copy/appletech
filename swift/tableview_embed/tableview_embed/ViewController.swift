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
        a.view.frame = CGRectMake(0,100,300,200)
        self.view.addSubview(a.view)
        self.addChildViewController(a)
    }
}




