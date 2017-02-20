//
//  1.swift
//  helloapp
//
//  Created by lcj on 2017/2/20.
//  Copyright © 2017年 liu. All rights reserved.
//

import UIKit

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
        cell!.imageView!.image = UIImage.imageWithColor(UIColor.green)
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
