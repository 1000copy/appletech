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
    open func scrollDown(doneHandler: @escaping(()->Void)){}
    open func scrollUp(doneHandler: @escaping(()->Void)){}

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame:frame,style:style)
        mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] in
            self?.scrollUp(){
                self?.mj_header.endRefreshing()
            }
        })
        mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {[weak self] in
            self?.scrollDown(){
                self?.mj_footer.endRefreshing()
            }
        })
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
    func onClick(){
       
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onClick()
    }

}

func v2Font(_ fontSize: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: fontSize);
}
import YYText

class Text {
    class func getYYLayout(_ title : String?)->YYTextLayout?{
        return getYYLayout(title,UIScreen.main.bounds.size.width - 24)
    }
    class func getYYLayout(_ title : String?, _ width : CGFloat)->YYTextLayout?{
        var topicTitleAttributedString: NSMutableAttributedString?
        var topicTitleLayout: YYTextLayout?
        let r :CGFloat = 15.0
        let g :CGFloat = 15.0
        let b :CGFloat = 15.0
        topicTitleAttributedString = NSMutableAttributedString(string: title!,
                                                               attributes: [
                                                                NSFontAttributeName:v2Font(17),
                                                                NSForegroundColorAttributeName:UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 255),
                                                                ])
        topicTitleAttributedString?.yy_lineSpacing = 3
        topicTitleLayout = YYTextLayout(containerSize: CGSize(width: width, height: 9999), text: topicTitleAttributedString!)
        return topicTitleLayout
    }
    class func OccupyHigh(_ title : String, _ width : CGFloat) -> CGFloat{
        let topicTitleLayout = getYYLayout(title,width)
        return topicTitleLayout?.textBoundingRect.size.height ?? 0
    }
}
