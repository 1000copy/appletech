
import UIKit


class ViewController: UIViewController
{
  var pageViewController : UIPageViewController?

  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    pageViewController = PageViewController()
//    pageViewController!.dataSource = self
    

    pageViewController!.view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height - 200);
    
    addChildViewController(pageViewController!)
    view.addSubview(pageViewController!.view)
    pageViewController!.didMoveToParentViewController(self)
  }
  

  
    
}
