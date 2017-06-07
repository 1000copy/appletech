import MJRefresh
import UIKit

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
        
        self.thmemChangedHandler = {[weak self] (style) -> Void in
            if V2EXColor.sharedInstance.style == V2EXColor.V2EXColorStyleDefault {
                self?.loadingView?.activityIndicatorViewStyle = .gray
                self?.stateLabel!.textColor = UIColor(white: 0, alpha: 0.3)
            }
            else{
                self?.loadingView?.activityIndicatorViewStyle = .white
                self?.stateLabel!.textColor = UIColor(white: 1, alpha: 0.3)
            }
        }
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
        
        self.thmemChangedHandler = {[weak self] (style) -> Void in
            if V2EXColor.sharedInstance.style == V2EXColor.V2EXColorStyleDefault {
                self?.loadingView?.activityIndicatorViewStyle = .gray
                self?.arrowImage?.tintColor = UIColor.gray
            }
            else{
                self?.loadingView?.activityIndicatorViewStyle = .white
                self?.arrowImage?.tintColor = UIColor.gray
            }
        }
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
