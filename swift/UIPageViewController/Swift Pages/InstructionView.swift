
import UIKit

class InstructionView: UIViewController
{
  
  var pageIndex : Int = 0
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    let label = UILabel(frame: CGRectMake(0, 0, view.frame.width, 200))
    label.textColor = UIColor.blueColor()
    label.text = "#" + String(pageIndex)
    label.textAlignment = .Center
    view.addSubview(label)
    
//    let button = UIButton(type: UIButtonType.System)
//    button.frame = CGRectMake(20, view.frame.height - 110, view.frame.width - 40, 50)
//    button.backgroundColor = UIColor(red: 138/255.0, green: 181/255.0, blue: 91/255.0, alpha: 1)
//    button.setTitle(titleText, forState: UIControlState.Normal)
//    button.addTarget(self, action: "Action:", forControlEvents: UIControlEvents.TouchUpInside)
//    self.view.addSubview(button)
  }
  
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }
  
}
