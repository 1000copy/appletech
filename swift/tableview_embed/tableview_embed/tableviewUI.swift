//
//  v2.swift
//  tableview_embed
//
//  Created by quota on 2/7/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit 


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
