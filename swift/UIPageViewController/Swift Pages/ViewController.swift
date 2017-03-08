
import UIKit


class ViewController: UIViewController
{
  var pageViewController : UIPageViewController?

  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    pageViewController = PageViewController()
//    pageViewController!.dataSource = self
    

    pageViewController!.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - 200);
    
    addChildViewController(pageViewController!)
    view.addSubview(pageViewController!.view)
    pageViewController!.didMove(toParentViewController: self)
  }
  

  
    
}
