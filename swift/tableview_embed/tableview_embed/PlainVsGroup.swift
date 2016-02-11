import UIKit

class LangTablePlain : UITableView,UITableViewDataSource{
    let arr = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]
    let arr1 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]
    let titles  = ["header1","header2"]
    let footers  = ["footer1","footer2"]
    convenience init(){
        self.init(frame: CGRectZero, style:UITableViewStyle.Plain)
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
            return arr.count
        }else{
            return arr1.count
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let a = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: nil)
        a.textLabel?.text = String(arr[indexPath.row])
        return a
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 2
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return titles[section]
    }
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String?{
        return footers[section]
    }
}
class LangTableGrouped : UITableView,UITableViewDataSource{
    let arr = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]
    let arr1 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]
    let titles  = ["header1","header2"]
    let footers  = ["footer1","footer2"]
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
            return arr.count
        }else{
            return arr1.count
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let a = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: nil)
        a.textLabel?.text = String(arr[indexPath.row])
        return a
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 2
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return titles[section]
    }
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String?{
        return footers[section]
    }
}

func PlainVsGrouped (view: UIView){
    let a  = LangTablePlain()
    a.frame = CGRectMake(0,200,300,200)
    view.addSubview(a)
    
    let b  = LangTableGrouped()
    b.frame = CGRectMake(0,400,300,200)
    view.addSubview(b)
}