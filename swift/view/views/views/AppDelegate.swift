import UIKit
class DemoCollectionView: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.itemSize = CGSize(width: 60, height: 60)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView)
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor.blackColor()
        return cell
    }
}
class DemoUIActivityIndicatorView :UIViewController{
    var acview : UIActivityIndicatorView?
    override func viewDidLoad() {
        acview = UIActivityIndicatorView()
        acview!.frame = CGRectMake(100, 100, 100, 100)
        view.addSubview(acview!)
        self.view.backgroundColor = UIColor.blackColor()

    }
    override func viewDidAppear(animated: Bool) {
        acview!.startAnimating()
    }
    override func viewDidDisappear(animated: Bool) {
        acview!.stopAnimating()
    }

}
// Alert View
class DemoAlertViewOfUIAlertController:UIViewController{
    override func viewDidAppear(animated: Bool) {
        Alert()
    }
    func Alert(){
        let alert = UIAlertController(title: "Hi", message: "I am message", preferredStyle:.Alert)
        // Closure
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
            print("OK")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler:nil))
        AppDelegate.Top?.presentViewController(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
    }

}


// Action Sheet
class DemoActionSheetOfUIAlertController:UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
    }
    override func viewDidAppear(animated: Bool) {
        ActionSheet()
    }
    func ActionSheet() {
        let sheet: UIAlertController = UIAlertController(title:nil, message:nil, preferredStyle:UIAlertControllerStyle.ActionSheet)
        sheet.addAction(UIAlertAction(title:"Do something 1", style:UIAlertActionStyle.Default, handler:{ action in
            print ("Do something 1")
        }))
        sheet.addAction(UIAlertAction(title:"Do something 2", style:UIAlertActionStyle.Default, handler:{ action in
            print ("Do something 2")
        }))
        sheet.addAction(UIAlertAction(title:"Cancel", style:UIAlertActionStyle.Cancel, handler:nil))
        AppDelegate.Top?.presentViewController(sheet, animated:true, completion:nil)
    }
}



class PageViewController :UIPageViewController,UIPageViewControllerDataSource{
    var vcs :[UIViewController]
    required init(){
        vcs = [DemoCollectionView(),DemoUIActivityIndicatorView(),DemoActionSheetOfUIAlertController(),DemoAlertViewOfUIAlertController()]
        super.init(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    }
    required  init?(coder: NSCoder){
        fatalError()
    }
    override func viewDidAppear(animated: Bool) {
        setViewControllers([vcs[0]], direction: .Forward, animated: false, completion: nil)
        
    }
    override func viewDidLoad() {
        self.dataSource = self

    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        let v = (viewController)
        let i = vcs.indexOf(v)! - 1
        if i < 0 {
            return nil
        }
        return vcs[i]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        let v = (viewController)
        let i = vcs.indexOf(v)! + 1
        if i > vcs.count - 1 {
            return nil
        }
        return vcs[i]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return vcs.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = DemoCollectionView()
        self.window?.makeKeyAndVisible()
        return true
    }
    //http://pinkstone.co.uk/how-to-avoid-whose-view-is-not-in-the-window-hierarchy-error-when-presenting-a-uiviewcontroller/
   func topMost ()-> UIViewController?{
        var  top = UIApplication.sharedApplication().keyWindow?.rootViewController!
        while top?.presentedViewController != nil{
            top = top!.presentedViewController
        }
        return top
    }
    class var Top :  UIViewController?{
        get {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).topMost()
        }
    }
}