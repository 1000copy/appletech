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
        
        self.arrowImage = UIImageView(image: imageUsedTemplateMode("ic_arrow_downward"))
        self.addSubview(self.arrowImage!)
        
    }
    func imageUsedTemplateMode(_ str : String)-> UIImage?{
        let image = UIImage(named: str)
        if image == nil {
            return nil
        }
        return image!.withRenderingMode(.alwaysTemplate)
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

let V2EXURL = "https://www.v2ex.com/"

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

