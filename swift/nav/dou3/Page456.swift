//
//  Page456.swift
//  dou3
//
//  Created by quota on 1/15/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

class CellTodo : UITableViewCell{
    var mainLabel : UILabel?
    var onoff : UISwitch?
    required override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style,reuseIdentifier: reuseIdentifier)
        
        f2()
        dolayout()
    }

    func f2(){
        mainLabel = UILabel()
        onoff = UISwitch()
        self.contentView.addSubview(mainLabel!)
        self.contentView.addSubview(onoff!)
        
        mainLabel!.translatesAutoresizingMaskIntoConstraints = false
        onoff!.translatesAutoresizingMaskIntoConstraints = false
        
       

    }
    func dolayout(){
        let views = ["view":self,"onoff":onoff!,"mainLabel":mainLabel!] //:[String:AnyObject]
        let m = ["padding":5]
        let vfls = [
            "H:|-padding-[mainLabel]",
            "V:|-padding-[mainLabel]-padding-[onoff]",
            "H:|-padding-[onoff]"]
        for index in 0...2 {
            let c =  NSLayoutConstraint.constraintsWithVisualFormat(vfls[index], options: .AlignAllLeft, metrics: m,views:views )
            self.addConstraints(c)
        }
    }
    func dolayout1(){
        let h1 = NSLayoutConstraint(item: mainLabel!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 5)
        self.addConstraint(h1)
        
        let v1 = NSLayoutConstraint(item: mainLabel!, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 5)
        self.addConstraint(v1)
        
        // for on off
        let h2 = NSLayoutConstraint(item: onoff!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: mainLabel!, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 5)
        self.addConstraint(h2)
        
        let v2 = NSLayoutConstraint(item: mainLabel!, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 5)
        self.addConstraint(v2)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
}

struct CellValue{
    var t1:String
    var t4: Bool
}
class PageTodo: UITableViewController {
    
    var selectRow : Int?
    var isAdd = false

    override func viewDidLoad() {
        super.viewDidLoad()
        //        navigationController!.navigationItem.rightBarButtonItem = editButtonItem()

        navigationItem.rightBarButtonItem = editButtonItem()
        let item = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "doAdd:")
        navigationItem.leftBarButtonItem = item
        
    }
    func doAdd(sender:UIButton!){
        print("tap add ")
        isAdd = true
        let p = NavTwo()
        presentViewController(p, animated: true){}
        
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return App.Delegate.cellValue.count
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
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
        
        c.mainLabel?.text = App.Delegate.cellValue[indexPath.row].t1
        c.onoff?.on = App.Delegate.cellValue[indexPath.row].t4
        return c;
        
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            App.Delegate.cellValue.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    override func tableView(tableView: UITableView,didSelectRowAtIndexPath indexPath: NSIndexPath){
        isAdd = false
        let p = NavTwo()
        selectRow = indexPath.row
        presentViewController(p, animated: true){}
        //        navigationController?.pushViewController(p, animated: true)
    }
    override func tableView(tableView: UITableView,shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool{
        return true
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

class NavTwo : UINavigationController{
    override func viewDidLoad() {
        super.viewDidLoad()
        let  p = PageTwo()
        //         navigationController?.navigationBar.topItem?.title = "page 1"
        viewControllers = [p]
        
    }
}

class PageTwo:Page{
    var mainLabel :UITextField!
    var onoff : UISwitch!
    var form : PageTodo?

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    func initUI(){
        view.backgroundColor = UIColor.whiteColor()
        mainLabel = UITextField()
        mainLabel.placeholder = "input TODO text"
        onoff = UISwitch()
        view.addSubview(mainLabel!)
        view.addSubview(onoff!)
        mainLabel.becomeFirstResponder()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "save:")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel:")
        // layout
        mainLabel!.translatesAutoresizingMaskIntoConstraints = false
        onoff!.translatesAutoresizingMaskIntoConstraints = false
        
       layoutit()

    }
    func layoutit(){
        let h1 = NSLayoutConstraint(item: mainLabel!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 80)
        self.view.addConstraint(h1)
        
        let v1 = NSLayoutConstraint(item: mainLabel!, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 5)
        self.view.addConstraint(v1)
        
        // for on off
        let h2 = NSLayoutConstraint(item: onoff!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: mainLabel!, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 5)
        self.view.addConstraint(h2)
        
        let v2 = NSLayoutConstraint(item: mainLabel!, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 5)
        self.view.addConstraint(v2)
    }
    func save(sender:UIButton!){
        if form!.isAdd {
            let v = CellValue(t1:mainLabel.text!,t4:onoff.on)
            App.Delegate.cellValue.append(v)
            form?.tableView.reloadData()
            dismissViewControllerAnimated(true){}
        }else{
            App.Delegate.cellValue[(form?.selectRow)!].t1 = mainLabel.text!
            App.Delegate.cellValue[(form?.selectRow)!].t4 = onoff.on
            form?.tableView.reloadData()
            dismissViewControllerAnimated(true){}
        }
    }
    func cancel(sender:UIButton!){
        dismissViewControllerAnimated(true){}
    }
    override func viewDidAppear(animated: Bool) {
        let p7 = App.Delegate.list
        if p7!.isAdd{
            mainLabel.text =  ""
            onoff.on = false
        }else {
            mainLabel.text =  App.Delegate.cellValue[p7!.selectRow!].t1
            onoff.on = App.Delegate.cellValue[p7!.selectRow!].t4
        }
        form = p7
    }
}