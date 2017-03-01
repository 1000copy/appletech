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
        self.init(frame: CGRect.zero, style:UITableViewStyle.grouped)
    }
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame:frame,style:style)
        self.dataSource = self
        self.tableHeaderView = UIView()
        self.tableHeaderView!.frame = CGRect(x: 0, y: 0,width: 200,height: 20)
        let l = UILabel()
        l.text = tableheader
        l.frame = CGRect(x: 0, y: 0,width: 200,height: 20)
        self.tableHeaderView?.addSubview(l)
        
        self.tableFooterView = UIView()
        self.tableFooterView!.frame = CGRect(x: 0, y: 0,width: 200,height: 20)
        let f = UILabel()
        f.text = tablefooter
        f.frame = CGRect(x: 0, y: 0,width: 200,height: 20)
        self.tableFooterView?.addSubview(f)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrs[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let a = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: nil)
        a.textLabel?.text = String(arrs[indexPath.section][indexPath.row])
        return a
    }
    func numberOfSections(in tableView: UITableView) -> Int{
        return arrs.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return titles[section]
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String?{
        return footers[section]
    }
    class func dock(_ view : UIView){
        let b  = LangTableTotalUI()
        b.frame = CGRect(x: 20,y: 20,width: 150,height: 500)
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
            image:UIImage.imageWithColor(UIColor.red),
            style: UITableViewCellStyle.default),
        Row(
            text:"java",
            text2:"old plain",
            image:UIImage.imageWithColor(UIColor.red),
            style: UITableViewCellStyle.value1),
        Row(
            text:"java",
            text2:"old plain",
            image:UIImage.imageWithColor(UIColor.red),
            style: UITableViewCellStyle.value2),
        Row(
            text:"java",
            text2:"old plain",
            image:UIImage.imageWithColor(UIColor.red),
            style: UITableViewCellStyle.subtitle)
    ]
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
        let a = UITableViewCell(style: arr[indexPath.row].style, reuseIdentifier: nil)
        a.textLabel?.text = arr[indexPath.row].text
        a.detailTextLabel?.text = arr[indexPath.row].text2
        a.imageView?.image = arr[indexPath.row].image
        return a
    }
    class func dock(_ view : UIView){
        let t = LangTableCellStyle();
        t.frame = CGRect(x: 0,y: 100,width: 200,height: 300)
        view.addSubview(t)
    }
    
}

class LangTableCustomCell : UITableViewCell{
    var mainLabel : UILabel?
    required override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        mainLabel = UILabel(frame:CGRect(x: 0.0, y: 0.0, width: 220.0, height: 15.0))
        mainLabel!.backgroundColor = UIColor.red
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let a = LangTableCustomCell(style: UITableViewCellStyle.value1, reuseIdentifier: nil)
        a.mainLabel?.text = arr[indexPath.row]
        return a
    }
}
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

class LangTableViewController : UITableViewController{
    let arr = ["swift","obj-c","ruby"]
    let MyIdentifier = "cell"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: MyIdentifier)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let a = tableView.dequeueReusableCell(withIdentifier: MyIdentifier)
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
            image:UIImage.imageWithColor(UIColor.red),
            access:UITableViewCellAccessoryType.checkmark,
            style: UITableViewCellStyle.value1),
        Row(
            text:"ruby",
            text2:"new cool slow",
            image:UIImage.imageWithColor(UIColor.green),
            access:UITableViewCellAccessoryType.detailButton,
            style: UITableViewCellStyle.value2),
        Row(
            text:"swift",
            text2:"new cool quick ",
            image:UIImage.imageWithColor(UIColor.blue),
            access:UITableViewCellAccessoryType.detailDisclosureButton,
            style: UITableViewCellStyle.subtitle)
    ]
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count / 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let a = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: nil)
        a.textLabel?.text = String(arr[indexPath.row])
        a.detailTextLabel?.text = String(arr[indexPath.row+1])
        a.imageView?.image = UIImage.imageWithColor(UIColor.red)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count / 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let a = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: nil)
        a.textLabel?.text = String(arr[indexPath.row])
        a.detailTextLabel?.text = String(arr[indexPath.row+1])
        a.imageView?.image = UIImage.imageWithColor(UIColor.red)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count / 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let a = UITableViewCell(style: UITableViewCellStyle.value2, reuseIdentifier: nil)
        a.textLabel?.text = String(arr[indexPath.row])
        a.detailTextLabel?.text = String(arr[indexPath.row+1])
        a.imageView?.image = UIImage.imageWithColor(UIColor.red)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let a = UITableViewCell(style: .default, reuseIdentifier: nil)
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
        self.register(UITableViewCell.self, forCellReuseIdentifier: MyIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let a = tableView.dequeueReusableCell(withIdentifier: MyIdentifier)!
        a.textLabel?.text = String(arr[indexPath.row])
        return a
    }
}
