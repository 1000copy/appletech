
import UIKit

class ViewController: UIViewController {
    var a : LangTableRowOper1?
    override func viewDidLoad() {
        super.viewDidLoad()
        a  = LangTableRowOper1()
        a!.frame = CGRectMake(0,200,300,200)
        self.view.addSubview(a!)
        let b = UIButton()
        b.setTitle("edit", forState: .Normal)
        b.backgroundColor = UIColor.redColor()
        b.addTarget(self, action: "edit:", forControlEvents: .TouchDown)
        
        let e = UIButton()
        e.setTitle("Done", forState: .Normal)
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


class LangTableRowOper1 : UITableView,UITableViewDataSource,UITableViewDelegate{
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

        let s = sourceIndexPath.row
        let d = destinationIndexPath.row
        let temp = arr[s]
        arr.removeObjectAtIndex(s)
        arr.insertObject(temp, atIndex: d)
    }
}


//class ViewController: UIViewController {
//    var a : LangTableRowDelete?
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        initui ()
//    }
//    func initui(){
//        a  = LangTableRowDelete()
//        a!.frame = CGRectMake(0,30,300,200)
//        self.view.addSubview(a!)
//        let b = UIButton()
//        b.setTitle("Edit", forState: .Normal)
//        b.backgroundColor = UIColor.redColor()
//        b.addTarget(self, action: "edit:", forControlEvents: .TouchDown)
//        b.frame = CGRectMake(0, 20, 100, 20)
//
//        let d = UIButton()
//        d.setTitle("Done", forState: .Normal)
//        d.backgroundColor = UIColor.greenColor()
//        d.addTarget(self, action: "done:", forControlEvents: .TouchDown)
//        d.frame = CGRectMake(110, 20, 100, 20)
//        self.view.addSubview(b)
//        self.view.addSubview(d)
//    }
//    func edit( b : UIButton!){
//        a!.setEditing(true, animated: true)
//    }
//    func done( b : UIButton!){
//        a!.setEditing(false, animated: true)
//    }
//}
//

