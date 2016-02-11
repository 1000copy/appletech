//
//  tableevent.swift
//  tableview_embed
//
//  Created by quota on 2/9/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    var a : LangTableRowDelete?
    override func viewDidLoad() {
        super.viewDidLoad()
        a  = LangTableRowDelete()
        a!.frame = CGRectMake(0,200,300,200)
        self.view.addSubview(a!)
        let b = UIButton()
        b.setTitle("edit", forState: .Normal)
        b.backgroundColor = UIColor.redColor()
        b.addTarget(self, action: "edit:", forControlEvents: .TouchDown)
        
        let c = UIButton()
        c.setTitle("add", forState: .Normal)
        c.backgroundColor = UIColor.yellowColor()
        c.addTarget(self, action: "add:", forControlEvents: .TouchDown)
        
        let d = UIButton()
        d.setTitle("update", forState: .Normal)
        d.backgroundColor = UIColor.blueColor()
        d.addTarget(self, action: "update:", forControlEvents: .TouchDown)
        

        let e = UIButton()
        e.setTitle("reordered", forState: .Normal)
        e.backgroundColor = UIColor.blueColor()
        e.addTarget(self, action: "reordered:", forControlEvents: .TouchDown)
        
        let sv = UIStackView()
        
        sv.backgroundColor = UIColor.grayColor()
        sv.axis = UILayoutConstraintAxis.Horizontal
        sv.distribution = .EqualCentering;
        sv.alignment = .Center;
        sv.spacing = 10;
        sv.frame = CGRectMake(0,100,300,50)
        sv.addArrangedSubview(b)
        sv.addArrangedSubview(c)
        sv.addArrangedSubview(d)
        sv.addArrangedSubview(e)
        sv.translatesAutoresizingMaskIntoConstraints = true
        self.view.addSubview(sv)
        
    }
    func edit( b : UIButton!){
        a!.setEditing(true, animated: true)
    }
    func add( b : UIButton!){
        a!.add("new lang")
    }
    func update( b : UIButton!){
        a!.update(1, newlang: "new lang")
    }
    func reordered( b : UIButton!){
        a!.setEditing(false, animated: true)
        a?.reloadData()
    }
}


class LangTableRowDelete : UITableView,UITableViewDataSource,UITableViewDelegate{
    var arr = NSMutableArray.init(array: ["java","swift","js"])
//    var arr = ["java","swift","js"]
    func add(newlang : String){
        
        arr.insertObject(newlang, atIndex: arr.count )
        beginUpdates()
        insertRowsAtIndexPaths([
            NSIndexPath(forRow: arr.count - 1  , inSection: 0)
            ], withRowAnimation: .Automatic)
        endUpdates()
//            reloadData()
    }
    func update(forRow : Int ,newlang : String){
        arr[forRow] = newlang
        let p = NSIndexPath(forRow: forRow, inSection: 0)
        self.reloadRowsAtIndexPaths([p], withRowAnimation: .Fade)
    }
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame:frame,style:style)
        self.dataSource = self
        self.delegate = self
        
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
        a.showsReorderControl = true
        return a
    }
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        if editing && indexPath.row == arr.count  {
            return UITableViewCellEditingStyle.Insert
        }else{
            return UITableViewCellEditingStyle.Delete
        }
//        return UITableViewCellEditingStyle.Insert
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle ==  .Delete{
            arr.removeObjectAtIndex(indexPath.row) // http://stackoverflow.com/questions/21870680/invalid-update-invalid-number-of-rows-in-section-0
            self.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true;
    }
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let f = sourceIndexPath.row
        let t = destinationIndexPath.row
        (arr[f], arr[t]) = (arr[t], arr[f])
    }
}


class LangTableMultiSelection : UITableView,UITableViewDataSource,UITableViewDelegate{
    let arr = ["java","swift","js"]
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame:frame,style:style)
        self.dataSource = self
        self.delegate = self
        
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
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let r = self.cellForRowAtIndexPath(indexPath)!
        if r.accessoryType == .None {
            r.accessoryType = .Checkmark
        }else{
            r.accessoryType = .None
        }
        self.deselectRowAtIndexPath(indexPath, animated: false)
    }
}

class LangTableSingleSelection : UITableView,UITableViewDataSource,UITableViewDelegate{
    let arr = ["java","swift","js"]
    var ii = NSIndexPath (index:-1)
    var selected = false
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame:frame,style:style)
        self.dataSource = self
        self.delegate = self
        
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
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if !selected {
            selected = true
            ii = indexPath
            self.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        }else{
            self.cellForRowAtIndexPath(ii)?.accessoryType = .None
            self.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
            ii = indexPath
        }
        self.deselectRowAtIndexPath(indexPath, animated: false)
    }
}

class LangTableAccessView : UITableView,UITableViewDataSource{
    let arr = ["java","swift","js"]
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
        let s = UISwitch()
        s.frame = CGRectMake(0,0,20,20)
        s.addTarget(self, action: "action:", forControlEvents: .ValueChanged)
        s.on = true
        a.accessoryView = s
        return a
    }
    func action(sender : UISwitch!){
        print(sender.on)
    }
}


class LangTableHandleSelection : UITableView,UITableViewDataSource,UITableViewDelegate{
    let arr = ["java","swift","js"]
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame:frame,style:style)
        self.dataSource = self
        self.delegate = self
        
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
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        print("did select \(indexPath.row)")
        self.deselectRowAtIndexPath(indexPath, animated: false)
        if  self.cellForRowAtIndexPath(indexPath)?.accessoryType !=  .Checkmark{
            self.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
        }else{
            self.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
        }
    }
}


