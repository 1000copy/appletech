import UIKit
let arrs = [["swift","c#","c++","delphi","c"],["javascript","php","python","ruby","tcl/tk","bash"]]
let titles  = ["compiler","interupter"]
class LangTablePlain : UITableView,UITableViewDataSource{
    convenience init(){
        self.init(frame: CGRectZero, style:UITableViewStyle.Plain)
    }
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame:frame,style:style)
        self.dataSource = self
        
    }
    required init?(coder aDecoder: NSCoder) {
         fatalError("NSCoding not supported")
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrs[0].count
        }else{
            return arrs[1].count
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let a = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: nil)
        a.textLabel?.text = String(arrs[indexPath.section][indexPath.row])
        return a
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 2
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return titles[section]
    }
}
class LangTableGrouped : UITableView,UITableViewDataSource{

    convenience init(){
        self.init(frame: CGRectZero, style:UITableViewStyle.Grouped)
    }
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame:frame,style:style)
        self.dataSource = self
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrs[0].count
        }else{
            return arrs[1].count
        }
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
}

func PlainVsGrouped (view: UIView){
    let a  = LangTablePlain()
    a.frame = CGRectMake(0,20,150,500)
    view.addSubview(a)
    
    let b  = LangTableGrouped()
    b.frame = CGRectMake(160,20,150,500)
    view.addSubview(b)
}