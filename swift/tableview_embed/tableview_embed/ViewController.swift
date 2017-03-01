
import UIKit

class ViewController: UIViewController {
    var a : LangTableRowOper1?
    override func viewDidLoad() {
        super.viewDidLoad()
        a  = LangTableRowOper1()
        a!.frame = CGRect(x: 0,y: 200,width: 300,height: 200)
        self.view.addSubview(a!)
        let b = UIButton()
        b.setTitle("edit", for: UIControlState())
        b.backgroundColor = UIColor.red
        b.addTarget(self, action: #selector(ViewController.edit(_:)), for: .touchDown)
        
        let e = UIButton()
        e.setTitle("Done", for: UIControlState())
        e.backgroundColor = UIColor.blue
        e.addTarget(self, action: #selector(ViewController.reordered(_:)), for: .touchDown)
        
        let sv = UIStackView()
        
        sv.backgroundColor = UIColor.gray
        sv.axis = UILayoutConstraintAxis.horizontal
        sv.distribution = .equalCentering;
        sv.alignment = .center;
        sv.spacing = 10;
        sv.frame = CGRect(x: 0,y: 100,width: 300,height: 50)
        sv.addArrangedSubview(b)

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


class LangTableRowOper1 : UITableView,UITableViewDataSource,UITableViewDelegate{
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

        let s = sourceIndexPath.row
        let d = destinationIndexPath.row
        let temp = arr[s]
        arr.removeObject(at: s)
        arr.insert(temp, at: d)
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

