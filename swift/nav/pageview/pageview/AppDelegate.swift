//
//  AppDelegate.swift
//  pageview
//
//  Created by quota on 1/24/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

import Foundation
import UIKit

class v1 : UIViewController{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let l = UIButton()
        l.frame = CGRectMake(100,100,100,100);
        l.backgroundColor = UIColor.redColor()
        l.setTitle("111", forState: .Normal)
        self.view.addSubview(l)
    }
}
class v2 : UIViewController{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let l = UIButton()
        l.frame = CGRectMake(100,100,100,100);
        l.backgroundColor = UIColor.redColor()
        l.setTitle("222", forState: .Normal)
        self.view.addSubview(l)
    }
    
}
class v3 : UIViewController{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let l = UIButton()
        l.frame = CGRectMake(100,100,100,100);
        l.backgroundColor = UIColor.redColor()
        l.setTitle("333", forState: .Normal)
        self.view.addSubview(l)
    }

}
class UIPageViewController1: UIPageViewController
{
    var pageIndex : Int = 0
    var pageViewController : UIPageViewController?
    var pageTitles : Array<String> = ["God vs Man", "Cool Breeze", "Fire Sky"]
    var pageImages : Array<String> = ["page1.png", "page2.png", "page3.png"]
    var currentIndex : Int = 0
    var views : [UIViewController] = []
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blueColor()
        views += [v1(),v2(),v3()]
//        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        
//        let startingViewController: InstructionView = viewControllerAtIndex(0)!
//        let viewControllers = [startingViewController]
//        pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
//        pageViewController!.view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
//        
//        addChildViewController(pageViewController!)
//        view.addSubview(pageViewController!.view)
//        pageViewController!.didMoveToParentViewController(self)
                let viewControllers = [views[0]]
                setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
//                pageViewController!.view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);

    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        var index = pageIndex
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index--
        
        return views[index]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        var index = pageIndex
        
        if index == NSNotFound {
            return nil
        }
        
        index++
        
        if (index == self.pageTitles.count) {
            return nil
        }
        
        return views[index]
    }
    
    func viewControllerAtIndex(index: Int) -> ViewController?
    {
//        if self.pageTitles.count == 0 || index >= self.pageTitles.count
//        {
//            return nil
//        }
//        
//        // Create a new view controller and pass suitable data.
//        let pageContentViewController = InstructionView()
//        pageContentViewController.imageFile = pageImages[index]
//        pageContentViewController.titleText = pageTitles[index]
//        pageContentViewController.pageIndex = index
//        currentIndex = index
//        
//        return pageContentViewController
        return nil
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return self.pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var page : UIPageViewController?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let pageControl = UIPageControl.appearance()
        pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageControl.currentPageIndicatorTintColor = UIColor.blackColor()
        pageControl.backgroundColor = UIColor.whiteColor()
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        page = UIPageViewController1()
//        page?.setViewControllers([UIViewController()], direction: .Forward, animated: true, completion: nil)
        self.window!.rootViewController = page
        self.window?.makeKeyAndVisible()
        return true
    }
}

