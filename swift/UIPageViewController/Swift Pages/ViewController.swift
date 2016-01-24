
import UIKit
//class ViewController : UIPageViewController{
//    var index = 0
//    override func viewDidLoad()
//    {
//        super.viewDidLoad()
//        
//        let viewControllers = [UIViewController()]
//        setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
//        view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height - 200);
//        
//        
//        didMoveToParentViewController(self)
//    }
//    init(){
//        super.init(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder:coder)
//    }
//    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
//    {
//        return 3
//    }
//    
//    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
//    {
//        return 0
//    }
//    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
//    {
//        if (index == 0) || (index == NSNotFound) {
//            return nil
//        }
//        index--
//        return UIViewController()
//    }
//    
//    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
//    {
//        if index == NSNotFound {
//            return nil
//        }
//        
//        index++
//        
//        if (index == 3) {
//            return nil
//        }
//        return UIViewController()
//    }
//    
//}
class ViewController: UIViewController, UIPageViewControllerDataSource
{
  var pageViewController : UIPageViewController?
  var currentIndex : Int = 0
  var count = 3
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    pageViewController!.dataSource = self
    
    let startingViewController: InstructionView = viewControllerAtIndex(0)!
    let viewControllers = [startingViewController]
    pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
    pageViewController!.view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height - 200);
    
    addChildViewController(pageViewController!)
    view.addSubview(pageViewController!.view)
    pageViewController!.didMoveToParentViewController(self)
  }
  
  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
  }
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
  {
    var index = (viewController as! InstructionView).pageIndex
    
    if (index == 0) || (index == NSNotFound) {
      return nil
    }
    
    index--
    
    return viewControllerAtIndex(index)
  }
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
  {
    var index = (viewController as! InstructionView).pageIndex
    
    if index == NSNotFound {
      return nil
    }
    
    index++
    
    if (index == count) {
      return nil
    }
    
    return viewControllerAtIndex(index)
  }
  
  func viewControllerAtIndex(index: Int) -> InstructionView?
  {
    if count == 0 || index >= count
    {
      return nil
    }
    
    let pageContentViewController = InstructionView()
    pageContentViewController.pageIndex = index
    currentIndex = index
    
    return pageContentViewController
  }
  
  func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
  {
    return count
  }
  
  func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
  {
    return 0
  }
  
}
