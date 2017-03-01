//
//  tableevent.swift
//  tableview_embed
//
//  Created by quota on 2/9/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

class LangTableRowDelete: UITableView,UITableViewDataSource,UITableViewDelegate{
    var arr = NSMutableArray.init(array: ["java","swift","js"])
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame:frame,style:style)
        self.dataSource = self
        self.delegate = self
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let a = UITableViewCell(style: .default, reuseIdentifier: nil)
        a.textLabel?.text = String(describing: arr[indexPath.row])
        return a
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle ==  .delete{
            arr.removeObject(at: indexPath.row)
            self.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        }
    }
    
}

class ViewController2: UIViewController {
    var a : LangTableRowOper?
    override func viewDidLoad() {
        super.viewDidLoad()
        a  = LangTableRowOper()
        a!.frame = CGRect(x: 0,y: 200,width: 300,height: 200)
        self.view.addSubview(a!)
        let b = UIButton()
        b.setTitle("edit", for: UIControlState())
        b.backgroundColor = UIColor.red
        b.addTarget(self, action: #selector(ViewController2.edit(_:)), for: .touchDown)
        
        let c = UIButton()
        c.setTitle("add", for: UIControlState())
        c.backgroundColor = UIColor.yellow
        c.addTarget(self, action: #selector(ViewController2.add(_:)), for: .touchDown)
        
        let d = UIButton()
        d.setTitle("update", for: UIControlState())
        d.backgroundColor = UIColor.blue
        d.addTarget(self, action: #selector(ViewController2.update(_:)), for: .touchDown)
        

        let e = UIButton()
        e.setTitle("reordered", for: UIControlState())
        e.backgroundColor = UIColor.blue
        e.addTarget(self, action: #selector(ViewController2.reordered(_:)), for: .touchDown)
        
        let sv = UIStackView()
        
        sv.backgroundColor = UIColor.gray
        sv.axis = UILayoutConstraintAxis.horizontal
        sv.distribution = .equalCentering;
        sv.alignment = .center;
        sv.spacing = 10;
        sv.frame = CGRect(x: 0,y: 100,width: 300,height: 50)
        sv.addArrangedSubview(b)
        sv.addArrangedSubview(c)
        sv.addArrangedSubview(d)
        sv.addArrangedSubview(e)
        sv.translatesAutoresizingMaskIntoConstraints = true
        self.view.addSubview(sv)
        
    }
    func edit( _ b : UIButton!){
        a!.setEditing(true, animated: true)
    }
    func add( _ b : UIButton!){
        a!.add("new lang")
    }
    func update( _ b : UIButton!){
        a!.update(1, newlang: "new lang")
    }
    func reordered( _ b : UIButton!){
        a!.setEditing(false, animated: true)
        a?.reloadData()
    }
}


class LangTableRowOper : UITableView,UITableViewDataSource,UITableViewDelegate{
    var arr = NSMutableArray.init(array: ["java","swift","js"])
//    var arr = ["java","swift","js"]
    func add(_ newlang : String){
        
        arr.insert(newlang, at: arr.count )
        beginUpdates()
        insertRows(at: [
            IndexPath(row: arr.count - 1  , section: 0)
            ], with: .automatic)
        endUpdates()
//            reloadData()
    }
    func update(_ forRow : Int ,newlang : String){
        arr[forRow] = newlang
        let p = IndexPath(row: forRow, section: 0)
        self.reloadRows(at: [p], with: .fade)
    }
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame:frame,style:style)
        self.dataSource = self
        self.delegate = self
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let a = UITableViewCell(style: .default, reuseIdentifier: nil)
        a.textLabel?.text = String(describing: arr[indexPath.row])
        a.showsReorderControl = true
        return a
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        if isEditing && indexPath.row == arr.count  {
            return UITableViewCellEditingStyle.insert
        }else{
            return UITableViewCellEditingStyle.delete
        }
//        return UITableViewCellEditingStyle.Insert
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle ==  .delete{
            arr.removeObject(at: indexPath.row) // http://stackoverflow.com/questions/21870680/invalid-update-invalid-number-of-rows-in-section-0
            self.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        }
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        return true;
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let a = UITableViewCell(style: .default, reuseIdentifier: nil)
        a.textLabel?.text = String(arr[indexPath.row])
        return a
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let r = self.cellForRow(at: indexPath)!
        if r.accessoryType == .none {
            r.accessoryType = .checkmark
        }else{
            r.accessoryType = .none
        }
        self.deselectRow(at: indexPath, animated: false)
    }
}

class LangTableSingleSelection : UITableView,UITableViewDataSource,UITableViewDelegate{
    let arr = ["java","swift","js"]
    var ii = IndexPath (index:-1)
    var selected = false
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame:frame,style:style)
        self.dataSource = self
        self.delegate = self
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let a = UITableViewCell(style: .default, reuseIdentifier: nil)
        a.textLabel?.text = String(arr[indexPath.row])
        return a
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if !selected {
            selected = true
            ii = indexPath
            self.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }else{
            self.cellForRow(at: ii)?.accessoryType = .none
            self.cellForRow(at: indexPath)?.accessoryType = .checkmark
            ii = indexPath
        }
        self.deselectRow(at: indexPath, animated: false)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let a = UITableViewCell(style: .default, reuseIdentifier: nil)
        a.textLabel?.text = String(arr[indexPath.row])
        let s = UISwitch()
        s.frame = CGRect(x: 0,y: 0,width: 20,height: 20)
        s.addTarget(self, action: #selector(LangTableAccessView.action(_:)), for: .valueChanged)
        s.isOn = true
        a.accessoryView = s
        return a
    }
    func action(_ sender : UISwitch!){
        print(sender.isOn)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let a = UITableViewCell(style: .default, reuseIdentifier: nil)
        a.textLabel?.text = String(arr[indexPath.row])
        return a
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("did select \(indexPath.row)")
        self.deselectRow(at: indexPath, animated: false)
        if  self.cellForRow(at: indexPath)?.accessoryType !=  .checkmark{
            self.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }else{
            self.cellForRow(at: indexPath)?.accessoryType = .none
        }
    }
}


