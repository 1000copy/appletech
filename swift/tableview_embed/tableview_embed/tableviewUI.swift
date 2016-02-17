//
//  v2.swift
//  tableview_embed
//
//  Created by quota on 2/7/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit 

class LangTableTotalUI : UITableView,UITableViewDataSource{
    let arrs = [["Row 1","Row 2"],["Row 1"]]
    let titles  = ["Section Title 1","Section Title 2"]
    let footers  = ["Section Footer 1","Section Footer 2"]
    let tableheader = "Table Header"
    let tablefooter = "Table Footer"
    convenience init(){
        self.init(frame: CGRectZero, style:UITableViewStyle.Grouped)
    }
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame:frame,style:style)
        self.dataSource = self
        self.tableHeaderView = UIView()
        self.tableHeaderView!.frame = CGRectMake(0, 0,200,20)
        let l = UILabel()
        l.text = tableheader
        l.frame = CGRectMake(0, 0,200,20)
        self.tableHeaderView?.addSubview(l)
        
        self.tableFooterView = UIView()
        self.tableFooterView!.frame = CGRectMake(0, 0,200,20)
        let f = UILabel()
        f.text = tablefooter
        f.frame = CGRectMake(0, 0,200,20)
        self.tableFooterView?.addSubview(f)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrs[section].count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let a = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: nil)
        a.textLabel?.text = String(arrs[indexPath.section][indexPath.row])
        return a
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return arrs.count
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return titles[section]
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String?{
        return footers[section]
    }
    class func dock(view : UIView){
        let b  = LangTableTotalUI()
        b.frame = CGRectMake(20,20,150,500)
        view.addSubview(b)
    }
}



class LangTableCellStyle: UITableView,UITableViewDataSource{
    class Row {
        var text : String = ""
        var text2 : String = ""
        var image : UIImage
        var style :  UITableViewCellStyle
        init( text : String ,text2:String ,image:UIImage,style :  UITableViewCellStyle){
            self.text = text
            self.text2 = text2
            self.image = image
            self.style = style
        }
    }
    let arr = [
        Row(
            text:"java",
            text2:"old plain",
            image:UIImage.imageWithColor(UIColor.redColor()),
            style: UITableViewCellStyle.Default),
        Row(
            text:"java",
            text2:"old plain",
            image:UIImage.imageWithColor(UIColor.redColor()),
            style: UITableViewCellStyle.Value1),
        Row(
            text:"java",
            text2:"old plain",
            image:UIImage.imageWithColor(UIColor.redColor()),
            style: UITableViewCellStyle.Value2),
        Row(
            text:"java",
            text2:"old plain",
            image:UIImage.imageWithColor(UIColor.redColor()),
            style: UITableViewCellStyle.Subtitle)
    ]
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
        let a = UITableViewCell(style: arr[indexPath.row].style, reuseIdentifier: nil)
        a.textLabel?.text = arr[indexPath.row].text
        a.detailTextLabel?.text = arr[indexPath.row].text2
        a.imageView?.image = arr[indexPath.row].image
        return a
    }
    class func dock(view : UIView){
        let t = LangTableCellStyle();
        t.frame = CGRectMake(0,100,200,300)
        view.addSubview(t)
    }
    
}

class LangTableCustomCell : UITableViewCell{
    var mainLabel : UILabel?
    required override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        mainLabel = UILabel(frame:CGRectMake(0.0, 0.0, 220.0, 15.0))
        mainLabel!.backgroundColor = UIColor.redColor()
        super.init(style: style,reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(mainLabel!)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
}
class LangTableCustom : UITableView,UITableViewDataSource{
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
        let a = LangTableCustomCell(style: UITableViewCellStyle.Value1, reuseIdentifier: nil)
        a.mainLabel?.text = arr[indexPath.row]
        return a
    }
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

class Row {
    var text : String = ""
    var text2 : String = ""
    var image : UIImage
    var access : UITableViewCellAccessoryType
    var style :  UITableViewCellStyle
    init( text : String ,text2:String ,image:UIImage,access:UITableViewCellAccessoryType,style :  UITableViewCellStyle){
        self.text = text
        self.text2 = text2
        self.image = image
        self.access = access
        self.style = style
    }
}
class LangTableManyStyle: UITableView,UITableViewDataSource{
    let arr = [
        Row(
            text:"java",
            text2:"old plain",
            image:UIImage.imageWithColor(UIColor.redColor()),
            access:UITableViewCellAccessoryType.Checkmark,
            style: UITableViewCellStyle.Value1),
        Row(
            text:"ruby",
            text2:"new cool slow",
            image:UIImage.imageWithColor(UIColor.greenColor()),
            access:UITableViewCellAccessoryType.DetailButton,
            style: UITableViewCellStyle.Value2),
        Row(
            text:"swift",
            text2:"new cool quick ",
            image:UIImage.imageWithColor(UIColor.blueColor()),
            access:UITableViewCellAccessoryType.DetailDisclosureButton,
            style: UITableViewCellStyle.Subtitle)
    ]
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
        let a = UITableViewCell(style: arr[indexPath.row].style, reuseIdentifier: nil)
        a.textLabel?.text = arr[indexPath.row].text
        a.detailTextLabel?.text = arr[indexPath.row].text2
        a.imageView?.image = arr[indexPath.row].image
        a.accessoryType = arr[indexPath.row].access

        return a
    }
}



class LangTableValue1 : UITableView,UITableViewDataSource{
    let arr = ["java","old plain"]
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame:frame,style:style)
        self.dataSource = self
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count / 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let a = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: nil)
        a.textLabel?.text = String(arr[indexPath.row])
        a.detailTextLabel?.text = String(arr[indexPath.row+1])
        a.imageView?.image = UIImage.imageWithColor(UIColor.redColor())
        return a
    }
}


class LangTableSubtitle : UITableView,UITableViewDataSource{
    let arr = ["java","old plain"]
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame:frame,style:style)
        self.dataSource = self
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count / 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let a = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: nil)
        a.textLabel?.text = String(arr[indexPath.row])
        a.detailTextLabel?.text = String(arr[indexPath.row+1])
        a.imageView?.image = UIImage.imageWithColor(UIColor.redColor())
        return a
    }
}
class LangTableValue2 : UITableView,UITableViewDataSource{
    let arr = ["java","old plain"]
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame:frame,style:style)
        self.dataSource = self
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count / 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let a = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: nil)
        a.textLabel?.text = String(arr[indexPath.row])
        a.detailTextLabel?.text = String(arr[indexPath.row+1])
        a.imageView?.image = UIImage.imageWithColor(UIColor.redColor())
        return a
    }
}

class LangTable : UITableView,UITableViewDataSource{
    let arr = ["swift","obj-c","ruby"]
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
