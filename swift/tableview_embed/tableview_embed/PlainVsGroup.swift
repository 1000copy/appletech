import UIKit
let arrs = [["swift","c#","c++","delphi","c"],["javascript","php","python","ruby","tcl/tk","bash"]]
let titles  = ["compiler","interupter"]
class LangTablePlain : UITableView,UITableViewDataSource{
    convenience init(){
        self.init(frame: CGRect.zero, style:UITableViewStyle.plain)
    }
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame:frame,style:style)
        self.dataSource = self
        
    }
    required init?(coder aDecoder: NSCoder) {
         fatalError("NSCoding not supported")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrs[0].count
        }else{
            return arrs[1].count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let a = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: nil)
        a.textLabel?.text = String(arrs[indexPath.section][indexPath.row])
        return a
    }

    func numberOfSections(in tableView: UITableView) -> Int{
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        return titles[section]
    }
}
class LangTableGrouped : UITableView,UITableViewDataSource{

    convenience init(){
        self.init(frame: CGRect.zero, style:UITableViewStyle.grouped)
    }
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame:frame,style:style)
        self.dataSource = self
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrs[0].count
        }else{
            return arrs[1].count
        }
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
}

func PlainVsGrouped (_ view: UIView){
    let a  = LangTablePlain()
    a.frame = CGRect(x: 0,y: 20,width: 150,height: 500)
    view.addSubview(a)
    
    let b  = LangTableGrouped()
    b.frame = CGRect(x: 160,y: 20,width: 150,height: 500)
    view.addSubview(b)
}
