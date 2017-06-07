import Kingfisher
import MJRefresh
import UIKit
import Alamofire
import Ji
typealias  OnCellData = (_ cell : UITableViewCell ,_ obj : Any)->Void
class Table: UITableView,UITableViewDataSource,UITableViewDelegate{
    var ds_ : [[Any]]?
    var onCellData_ : OnCellData?
    var onCellData : OnCellData?{
        get{return onCellData_}
        set{
            onCellData_ = newValue
        }
    }
    open func scrollDown(){}
    open func scrollUp(){}

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame:frame,style:style)
        mj_header = MJHeader(refreshingBlock: {[weak self] in
            self?.scrollUp()
            self?.mj_header.endRefreshing()
        })
        let footer = MJFooter(refreshingBlock: {[weak self] () -> Void in
            self?.scrollDown()
            self?.mj_footer.endRefreshing()
        })
        footer?.centerOffset = -4
        mj_footer = footer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public var  ds : [[Any]]?{
        get{return ds_}
        set{
            ds_ = newValue
        }
    }
    var  cellClass_ : AnyClass?
    public var  cellClass : AnyClass?{
        get{return cellClass_}
        set{cellClass_ = newValue}
    }
    func load(){
        self.dataSource = self
        self.delegate = self
        register( cellClass, forCellReuseIdentifier: "\(cellClass)");
        reloadData()
        print("\(cellClass)")
    }
    func numberOfSections(in: UITableView) -> Int {
        return ds!.count
    }
    // 就说怎么cell上面有空白？调了很久
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 44
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ds![section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arr = ds!
        let a  = dequeueReusableCell(withIdentifier: "\(cellClass)", for: indexPath) ;
        loadCell(a,arr[indexPath.section][indexPath.row])
        return a
    }
    func loadCell(_ cell : UITableViewCell,_ item : Any){
        onCellData_?(cell,item)
    }
}
class MJFooter: MJRefreshAutoFooter {
    
    var loadingView:UIActivityIndicatorView?
    var stateLabel:UILabel?
    
    var centerOffset:CGFloat = 0
    
    fileprivate var _noMoreDataStateString:String?
    var noMoreDataStateString:String? {
        get{
            return self._noMoreDataStateString
        }
        set{
            self._noMoreDataStateString = newValue
            self.stateLabel?.text = newValue
        }
    }
    
    override var state:MJRefreshState{
        didSet{
            switch state {
            case .idle:
                self.stateLabel?.text = nil
                self.loadingView?.isHidden = true
                self.loadingView?.stopAnimating()
            case .refreshing:
                self.stateLabel?.text = nil
                self.loadingView?.isHidden = false
                self.loadingView?.startAnimating()
            case .noMoreData:
                self.stateLabel?.text = self.noMoreDataStateString
                self.loadingView?.isHidden = true
                self.loadingView?.stopAnimating()
            default:break
            }
        }
    }
    
    /**
     初始化工作
     */
    override func prepare() {
        super.prepare()
        self.mj_h = 50
        
        self.loadingView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        self.addSubview(self.loadingView!)
        
        self.stateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        self.stateLabel?.textAlignment = .center
        self.stateLabel!.font = v2Font(12)
        self.addSubview(self.stateLabel!)
        
        self.noMoreDataStateString = "没有更多数据了"
    
    }
    
    /**
     在这里设置子控件的位置和尺寸
     */
    override func placeSubviews(){
        super.placeSubviews()
        self.loadingView!.center = CGPoint(x: self.mj_w/2, y: self.mj_h/2 + self.centerOffset);
        self.stateLabel!.center = CGPoint(x: self.mj_w/2, y: self.mj_h/2  + self.centerOffset);
    }
    
}
class MJHeader: MJRefreshHeader {
    var loadingView:UIActivityIndicatorView?
    var arrowImage:UIImageView?
    
    override var state:MJRefreshState{
        didSet{
            switch state {
            case .idle:
                self.loadingView?.isHidden = true
                self.arrowImage?.isHidden = false
                self.loadingView?.stopAnimating()
            case .pulling:
                self.loadingView?.isHidden = false
                self.arrowImage?.isHidden = true
                self.loadingView?.startAnimating()
                
            case .refreshing:
                self.loadingView?.isHidden = false
                self.arrowImage?.isHidden = true
                self.loadingView?.startAnimating()
            default:
                NSLog("")
            }
        }
    }
    
    /**
     初始化工作
     */
    override func prepare() {
        super.prepare()
        self.mj_h = 50
        
        self.loadingView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        self.addSubview(self.loadingView!)
        
        self.arrowImage = UIImageView(image: UIImage.imageUsedTemplateMode("ic_arrow_downward"))
        self.addSubview(self.arrowImage!)
        
    }
    
    /**
     在这里设置子控件的位置和尺寸
     */
    override func placeSubviews(){
        super.placeSubviews()
        self.loadingView!.center = CGPoint(x: self.mj_w/2, y: self.mj_h/2);
        self.arrowImage!.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        self.arrowImage!.center = self.loadingView!.center
    }
    
    override func scrollViewContentOffsetDidChange(_ change: [AnyHashable: Any]!) {
        super.scrollViewContentOffsetDidChange(change)
    }
    
    override func scrollViewContentSizeDidChange(_ change: [AnyHashable: Any]!) {
        super.scrollViewContentOffsetDidChange(change)
    }
    
    override func scrollViewPanStateDidChange(_ change: [AnyHashable: Any]!) {
        super.scrollViewPanStateDidChange(change)
    }
    
}
func v2Font(_ fontSize: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: fontSize);
}

extension UIImage {
    
    func roundedCornerImageWithCornerRadius(_ cornerRadius:CGFloat) -> UIImage {
        
        let w = self.size.width
        let h = self.size.height
        
        var targetCornerRadius = cornerRadius
        if cornerRadius < 0 {
            targetCornerRadius = 0
        }
        if cornerRadius > min(w, h) {
            targetCornerRadius = min(w,h)
        }
        
        let imageFrame = CGRect(x: 0, y: 0, width: w, height: h)
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        
        UIBezierPath(roundedRect: imageFrame, cornerRadius: targetCornerRadius).addClip()
        self.draw(in: imageFrame)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    class func imageUsedTemplateMode(_ named:String) -> UIImage? {
        let image = UIImage(named: named)
        if image == nil {
            return nil
        }
        return image!.withRenderingMode(.alwaysTemplate)
    }
}
func fin_defaultImageModification() -> ((_ image:UIImage) -> UIImage) {
    return { ( image) -> UIImage in
        let roundedImage = image.roundedCornerImageWithCornerRadius(3)
        return roundedImage
    }
}
import Kingfisher
private var lastURLKey: Void?
extension UIImageView {
    
    public var fin_webURL: URL? {
        return objc_getAssociatedObject(self, &lastURLKey) as? URL
    }
    
    fileprivate func fin_setWebURL(_ URL: Foundation.URL) {
        objc_setAssociatedObject(self, &lastURLKey, URL, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func fin_setImageWithUrl (_ URL: Foundation.URL ,placeholderImage: UIImage? = nil
        ,imageModificationClosure:((_ image:UIImage) -> UIImage)? = nil){
        
        self.image = placeholderImage
        
        let resource = ImageResource(downloadURL: URL)
        fin_setWebURL(resource.downloadURL)
        KingfisherManager.shared.cache.retrieveImage(forKey: resource.cacheKey, options: nil) { (image, cacheType) -> () in
            if image != nil {
                dispatch_sync_safely_main_queue({ () -> () in
                    self.image = image
                })
            }
            else {
                KingfisherManager.shared.downloader.downloadImage(with: resource.downloadURL, options: nil, progressBlock: nil, completionHandler: { (image, error, imageURL, originalData) -> () in
                    if let error = error , error.code == KingfisherError.notModified.rawValue {
                        KingfisherManager.shared.cache.retrieveImage(forKey: resource.cacheKey, options: nil, completionHandler: { (cacheImage, cacheType) -> () in
                            self.fin_setImage(cacheImage!, imageURL: imageURL!)
                        })
                        return
                    }
                    
                    if var image = image, let originalData = originalData {
                        //处理图片
                        if let img = imageModificationClosure?(image) {
                            image = img
                        }
                        
                        //保存图片缓存
                        KingfisherManager.shared.cache.store(image, original: originalData, forKey: resource.cacheKey, toDisk: true, completionHandler: nil)
                        self.fin_setImage(image, imageURL: imageURL!)
                    }
                })
            }
        }
    }
    
    fileprivate func fin_setImage(_ image:UIImage,imageURL:URL) {
        
        dispatch_sync_safely_main_queue { () -> () in
            guard imageURL == self.fin_webURL else {
                return
            }
            self.image = image
        }
        
    }
    
}

func fin_defaultImageModification2() -> ((_ image:UIImage) -> UIImage) {
    return { ( image) -> UIImage in
        let roundedImage = image.roundedCornerImageWithCornerRadius(3)
        return roundedImage
    }
}
func dispatch_sync_safely_main_queue(_ block: ()->()) {
    if Thread.isMainThread {
        block()
    } else {
        DispatchQueue.main.sync {
            block()
        }
    }
}
let V2EXURL = "https://www.v2ex.com/"
//使用协议 方便以后切换颜色配置文件、或者做主题配色之类乱七八糟产品经理最爱的功能
protocol V2EXColorProtocol{
    var v2_backgroundColor: UIColor { get }
    var v2_navigationBarTintColor: UIColor { get }
    var v2_TopicListTitleColor : UIColor { get }
    var v2_TopicListUserNameColor : UIColor { get }
    var v2_TopicListDateColor : UIColor { get }
    
    var v2_LinkColor : UIColor { get }
    
    var v2_TextViewBackgroundColor: UIColor { get }
    
    var v2_CellWhiteBackgroundColor : UIColor { get }
    
    var v2_NodeBackgroundColor : UIColor { get }
    
    var v2_SeparatorColor : UIColor { get }
    
    var v2_LeftNodeBackgroundColor : UIColor { get }
    var v2_LeftNodeBackgroundHighLightedColor : UIColor { get }
    var v2_LeftNodeTintColor: UIColor { get }
    
    /// 小红点背景颜色
    var v2_NoticePointColor : UIColor { get }
    
    var v2_ButtonBackgroundColor : UIColor { get }
}

class V2EXDefaultColor: NSObject,V2EXColorProtocol {
    static let sharedInstance = V2EXDefaultColor()
    fileprivate override init(){
        super.init()
    }
    
    var v2_backgroundColor : UIColor{
        get{
            return colorWith255RGB(242, g: 243, b: 245);
        }
    }
    var v2_navigationBarTintColor : UIColor{
        get{
            return colorWith255RGB(102, g: 102, b: 102);
        }
    }
    
    
    var v2_TopicListTitleColor : UIColor{
        get{
            return colorWith255RGB(15, g: 15, b: 15);
        }
    }
    
    var v2_TopicListUserNameColor : UIColor{
        get{
            return colorWith255RGB(53, g: 53, b: 53);
        }
    }
    
    var v2_TopicListDateColor : UIColor{
        get{
            return colorWith255RGB(173, g: 173, b: 173);
        }
    }
    
    var v2_LinkColor : UIColor {
        get {
            return colorWith255RGB(119, g: 128, b: 135)
        }
    }
    
    var v2_TextViewBackgroundColor :UIColor {
        get {
            return colorWith255RGB(255, g: 255, b: 255)
        }
    }
    
    var v2_CellWhiteBackgroundColor :UIColor {
        get {
            return colorWith255RGB(255, g: 255, b: 255)
        }
    }
    
    var v2_NodeBackgroundColor : UIColor {
        get {
            return colorWith255RGB(242, g: 242, b: 242)
        }
    }
    var v2_SeparatorColor : UIColor {
        get {
            return colorWith255RGB(190, g: 190, b: 190)
        }
    }
    
    var v2_LeftNodeBackgroundColor : UIColor {
        get {
            return colorWith255RGBA(255, g: 255, b: 255, a: 76)
        }
    }
    var v2_LeftNodeBackgroundHighLightedColor : UIColor {
        get {
            return colorWith255RGBA(255, g: 255, b: 255, a: 56)
        }
    }
    var v2_LeftNodeTintColor : UIColor {
        get {
            return colorWith255RGBA(0, g: 0, b: 0, a: 140)
        }
    }
    
    var v2_NoticePointColor : UIColor {
        get {
            return colorWith255RGB(207, g: 70, b: 71)
        }
    }
    var v2_ButtonBackgroundColor : UIColor {
        get {
            return colorWith255RGB(85, g: 172, b: 238)
        }
    }
}


/// Dark Colors
class V2EXDarkColor: NSObject,V2EXColorProtocol {
    static let sharedInstance = V2EXDarkColor()
    fileprivate override init(){
        super.init()
    }
    
    var v2_backgroundColor : UIColor{
        get{
            return colorWith255RGB(32, g: 31, b: 35);
        }
    }
    var v2_navigationBarTintColor : UIColor{
        get{
            return colorWith255RGB(165, g: 165, b: 165);
        }
    }
    
    
    var v2_TopicListTitleColor : UIColor{
        get{
            return colorWith255RGB(145, g: 145, b: 145);
        }
    }
    
    var v2_TopicListUserNameColor : UIColor{
        get{
            return colorWith255RGB(125, g: 125, b: 125);
        }
    }
    
    var v2_TopicListDateColor : UIColor{
        get{
            return colorWith255RGB(100, g: 100, b: 100);
        }
    }
    
    var v2_LinkColor : UIColor {
        get {
            return colorWith255RGB(119, g: 128, b: 135)
        }
    }
    
    var v2_TextViewBackgroundColor :UIColor {
        get {
            return colorWith255RGB(35, g: 34, b: 38)
        }
    }
    
    var v2_CellWhiteBackgroundColor :UIColor {
        get {
            return colorWith255RGB(35, g: 34, b: 38)
        }
    }
    
    var v2_NodeBackgroundColor : UIColor {
        get {
            return colorWith255RGB(40, g: 40, b: 40)
        }
    }
    var v2_SeparatorColor : UIColor {
        get {
            return colorWith255RGB(46, g: 45, b: 49)
        }
    }
    
    var v2_LeftNodeBackgroundColor : UIColor {
        get {
            return colorWith255RGBA(255, g: 255, b: 255, a: 76)
        }
    }
    var v2_LeftNodeBackgroundHighLightedColor : UIColor {
        get {
            return colorWith255RGBA(255, g: 255, b: 255, a: 56)
        }
    }
    var v2_LeftNodeTintColor : UIColor {
        get {
            return colorWith255RGBA(0, g: 0, b: 0, a: 140)
        }
    }
    
    var v2_NoticePointColor : UIColor {
        get {
            return colorWith255RGB(207, g: 70, b: 71)
        }
    }
    var v2_ButtonBackgroundColor : UIColor {
        get {
            return colorWith255RGB(207, g: 70, b: 71)
        }
    }
}


class V2EXColor :NSObject  {
    fileprivate static let STYLE_KEY = "styleKey"
    
    static let V2EXColorStyleDefault = "Default"
    static let V2EXColorStyleDark = "Dark"
    
    fileprivate static var _colors:V2EXColorProtocol?
    static var colors :V2EXColorProtocol {
        get{
            
            if let c = V2EXColor._colors {
                return c
            }
            else{
                if V2EXColor.sharedInstance.style == V2EXColor.V2EXColorStyleDefault{
                    return V2EXDefaultColor.sharedInstance
                }
                else{
                    return V2EXDarkColor.sharedInstance
                }
            }
            
        }
        set{
            V2EXColor._colors = newValue
        }
    }
    
    dynamic var style:String
    static let sharedInstance = V2EXColor()
    fileprivate override init(){
        if let style = V2EXSettings.sharedInstance[V2EXColor.STYLE_KEY] {
            self.style = style
        }
        else{
            self.style = V2EXColor.V2EXColorStyleDefault
        }
        super.init()
    }
    func setStyleAndSave(_ style:String){
        if self.style == style {
            return
        }
        
        if style == V2EXColor.V2EXColorStyleDefault {
            V2EXColor.colors = V2EXDefaultColor.sharedInstance
        }
        else{
            V2EXColor.colors = V2EXDarkColor.sharedInstance
        }
        
        self.style = style
        V2EXSettings.sharedInstance[V2EXColor.STYLE_KEY] = style
    }
    
}
let USER_AGENT = "Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.3 (KHTML, like Gecko) Version/8.0 Mobile/12A4345d Safari/600.1.4";
let MOBILE_CLIENT_HEADERS = ["user-agent":USER_AGENT]
let keyPrefix =  "me.fin.V2EXSettings."

class V2EXSettings: NSObject {
    static let sharedInstance = V2EXSettings()
    fileprivate override init(){
        super.init()
    }
    
    subscript(key:String) -> String? {
        get {
            return UserDefaults.standard.object(forKey: keyPrefix + key) as? String
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: keyPrefix + key )
        }
    }
}
extension String {
    public var Lenght:Int {
        get{
            return self.characters.count;
        }
    }
}
func colorWith255RGB(_ r:CGFloat , g:CGFloat, b:CGFloat) ->UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 255)
}
func colorWith255RGBA(_ r:CGFloat , g:CGFloat, b:CGFloat,a:CGFloat) ->UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a/255)
}
extension DataRequest {
    enum ErrorCode: Int {
        case noData = 1
        case dataSerializationFailed = 2
    }
    internal static func newError(_ code: ErrorCode, failureReason: String) -> NSError {
        let errorDomain = "me.fin.v2ex.error"
        let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
        let returnError = NSError(domain: errorDomain, code: code.rawValue, userInfo: userInfo)
        return returnError
    }
    
    static func JIHTMLResponseSerializer() -> DataResponseSerializer<Ji> {
        return DataResponseSerializer { request, response, data, error in
            guard error == nil else { return .failure(error!) }
            
            guard let validData = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            if  let jiHtml = Ji(htmlData: validData){
                return .success(jiHtml)
            }
            
            let failureReason = "ObjectMapper failed to serialize response."
            let error = newError(.dataSerializationFailed, failureReason: failureReason)
            return .failure(error)
        }
    }
    
    @discardableResult
    public func responseJiHtml(queue: DispatchQueue? = nil,  completionHandler: @escaping (DataResponse<Ji>) -> Void) -> Self {
        return response(responseSerializer: Alamofire.DataRequest.JIHTMLResponseSerializer(), completionHandler: completionHandler);
    }
}

