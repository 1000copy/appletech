import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.rootViewController = Page()
        self.window?.makeKeyAndVisible()
        return true
    }
}

//class DemoCollectionView: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
//    var collectionView: UICollectionView!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
//        layout.itemSize = CGSize(width: 60, height: 60)
//        
//        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
//        collectionView.backgroundColor = UIColor.white
//        self.view.addSubview(collectionView)
//    }
//    func numberOfSections(in collectionView: UICollectionView) -> Int{
//        return 1
//    }
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 5
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
//        cell.backgroundColor = UIColor.black
//        return cell
//    }
//}
//class DemoUIActivityIndicatorView :UIViewController{
//    var acview : UIActivityIndicatorView?
//    override func viewDidLoad() {
//        acview = UIActivityIndicatorView()
//        acview!.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
//        view.addSubview(acview!)
//        self.view.backgroundColor = UIColor.black
//        
//    }
//    override func viewDidAppear(_ animated: Bool) {
//        acview!.startAnimating()
//    }
//    override func viewDidDisappear(_ animated: Bool) {
//        acview!.stopAnimating()
//    }
//    
//}
//// Alert View
//class DemoAlertViewOfUIAlertController:UIViewController{
//    override func viewDidAppear(_ animated: Bool) {
//        Alert()
//    }
//    func Alert(){
//        let alert = UIAlertController(title: "Hi", message: "I am message", preferredStyle:.alert)
//        // Closure
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
//            print("OK")
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler:nil))
//        AppDelegate.Top?.present(alert, animated: true, completion: nil)
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = UIColor.black
//    }
//    
//}
//
//
//// Action Sheet
//class DemoActionSheetOfUIAlertController:UIViewController{
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = UIColor.black
//    }
//    override func viewDidAppear(_ animated: Bool) {
//        ActionSheet()
//    }
//    func ActionSheet() {
//        let sheet: UIAlertController = UIAlertController(title:nil, message:nil, preferredStyle:UIAlertControllerStyle.actionSheet)
//        sheet.addAction(UIAlertAction(title:"Do something 1", style:UIAlertActionStyle.default, handler:{ action in
//            print ("Do something 1")
//        }))
//        sheet.addAction(UIAlertAction(title:"Do something 2", style:UIAlertActionStyle.default, handler:{ action in
//            print ("Do something 2")
//        }))
//        sheet.addAction(UIAlertAction(title:"Cancel", style:UIAlertActionStyle.cancel, handler:nil))
//        AppDelegate.Top?.present(sheet, animated:true, completion:nil)
//    }
//}
//
//
//
//class PageViewController :UIPageViewController,UIPageViewControllerDataSource{
//    var vcs :[UIViewController]
//    required init(){
//        vcs = [
//            //            DemoWebViewController(),
//            DemoTextViewViewController(),
//            DemoSearchBarViewController(),
//            DemoScrollView(),
//            DemoProgressBarViewController(),DemoPickerViewController(),DemoImageViewAnimating(),DemoImageView(),DemoCollectionView(),DemoUIActivityIndicatorView(),DemoActionSheetOfUIAlertController(),DemoAlertViewOfUIAlertController()]
//        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//    }
//    required  init?(coder: NSCoder){
//        fatalError()
//    }
//    override func viewDidAppear(_ animated: Bool) {
//        setViewControllers([vcs[0]], direction: .forward, animated: false, completion: nil)
//        
//    }
//    override func viewDidLoad() {
//        self.dataSource = self
//        
//    }
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
//    {
//        let v = (viewController)
//        let i = vcs.index(of: v)! - 1
//        if i < 0 {
//            return nil
//        }
//        return vcs[i]
//    }
//    
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
//    {
//        let v = (viewController)
//        let i = vcs.index(of: v)! + 1
//        if i > vcs.count - 1 {
//            return nil
//        }
//        return vcs[i]
//    }
//    
//    func presentationCount(for pageViewController: UIPageViewController) -> Int
//    {
//        return vcs.count
//    }
//    
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int
//    {
//        return 0
//    }
//    
//}
//

class Page1: UIViewController{
    var c : UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        c = UIWebView()
        c.frame = super.view.frame
        view.addSubview(c)
        c.frame.origin.y += 20
        let url = URL(string:"http://apple.com")
        let ro = URLRequest(url:url!)
        c.loadRequest(ro)
    }
}
class Page2: UIViewController,UITextViewDelegate{
    var c : UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        c = UITextView()
        c.frame = CGRect(x: 10, y: 50, width: 200, height: 400)
        view.addSubview(c)
        c.text = "text\nand new lines\nand more lines"
        c.delegate = self
    }
    
    func textViewDidChange(_ textView: UITextView){
        // 字符串内的对象和属性写错了，一样可以报编译错。
        print ("new value : \(c.text)")
    }
}
class Page3: UIViewController,UISearchBarDelegate{
    var c : UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        c = UISearchBar()
        c.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        view.addSubview(c)
        c.delegate = self
        c.showsCancelButton = true
        c.showsBookmarkButton = true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print ("search : \(searchBar.text)")
    }
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print ("bookmark : \(searchBar.text)")
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print ("cancel : \(searchBar.text)")
    }
}


class Page4: UIViewController {
    var scroll: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.scroll = UIScrollView()
        scroll.backgroundColor = UIColor.red
        self.scroll.contentSize = CGSize(width: 100, height: 300)
        scroll.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        for i in 0  ..< 3 {
            let b = UILabel()
            b.backgroundColor = UIColor.blue
            b.frame = CGRect(x: 0, y: CGFloat(100 * i) , width: 100, height: 100)
            b.backgroundColor = UIColor.green
            b.text = "Drag Me ! "
            scroll.addSubview(b)
        }
        view.addSubview(scroll)
    }
}

//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//    var window: UIWindow?
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        self.window!.rootViewController = Page()
//        self.window?.makeKeyAndVisible()
//        return true
//    }
//    //http://pinkstone.co.uk/how-to-avoid-whose-view-is-not-in-the-window-hierarchy-error-when-presenting-a-uiviewcontroller/
//   func topMost ()-> UIViewController?{
//        var  top = UIApplication.shared.keyWindow?.rootViewController!
//        while top?.presentedViewController != nil{
//            top = top!.presentedViewController
//        }
//        return top
//    }
//    class var Top :  UIViewController?{
//        get {
//        return (UIApplication.shared.delegate as! AppDelegate).topMost()
//        }
//    }
//}


// progress bar.进度值从 0到 1 ，而不是从 0 到 100
class Page5: UIViewController{
    var timer : Timer!
    var pv: UIProgressView!
    var pv1: UIProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(Page5.update), userInfo: nil, repeats: true)
        pv = UIProgressView()
        pv.frame = CGRect(x: 100, y: 100, width: 100, height: 10)
        view.addSubview(pv)
        pv.progress = 0.51
        pv.progressViewStyle = .bar
        
    }
    func update() {
        pv.progress = pv.progress +  0.01
        if pv.progress >= 1 {
            pv.progress = 0
        }
    }
}
// picker view
class Page6: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var p: UIPickerView!
    let values = [["1", "2", "3"],["one", "two", "three"]]
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return values[component].count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return values[component][row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        print(values[component][row])
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // 这个frame太小的话，会看不到文字，以至于误以为代码错误。
        p = UIPickerView()
        p.frame =  CGRect(x: 10,y: 50,width: 320,height: 200)
        p.dataSource = self
        p.delegate = self
        view.addSubview(p)
    }
}
extension UIImage {
    class func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 10.0,height: 10.0 )
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
//Animating a Sequence of Images
class Page101: UIViewController {
    var bgImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bgImage = UIImageView()
        bgImage!.frame = CGRect(x: 0,y: 0,width: 100,height: 100)
        bgImage.image = UIImage.imageWithColor(UIColor.red)
        self.view.addSubview(bgImage!)
    }
}
class Page100: UIViewController {
    var bgImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bgImage = UIImageView()
        bgImage.animationImages = [UIImage.imageWithColor(UIColor.red),
                                   UIImage.imageWithColor(UIColor.yellow),
                                   UIImage.imageWithColor(UIColor.black),
                                   UIImage.imageWithColor(UIColor.blue)]
        bgImage!.frame = CGRect(x: 0,y: 0,width: 100,height: 100)
        self.view.addSubview(bgImage!)
        bgImage.animationDuration = 1
        bgImage.startAnimating()
    }
    override func viewDidDisappear(_ animated: Bool) {
        bgImage.stopAnimating()
    }
}
class Page102: UIViewController {
    var v: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let image1 = UIImage.imageWithColor(UIColor.red)
        let image2 = UIImage.imageWithColor(UIColor.blue)
        v = UIImageView(image: image1,highlightedImage:image2)
        v!.frame = CGRect(x: 0,y: 0,width: 100,height: 100)
        self.view.addSubview(v!)
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(_:)))
        v.isUserInteractionEnabled = true
        v.addGestureRecognizer(tapGestureRecognizer)
    }
    func imageTapped(_ img: AnyObject)
    {
        v.isHighlighted = !v!.isHighlighted
    }
}
