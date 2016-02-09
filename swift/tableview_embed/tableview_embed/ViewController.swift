
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
        
    }
}



