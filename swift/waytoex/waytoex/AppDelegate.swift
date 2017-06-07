

import UIKit

import MJRefresh

import Kingfisher
import ObjectMapper
import Ji
import YYText

import KeychainSwift
import SnapKit

import Alamofire
import AlamofireObjectMapper

import KVOController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        let nav = UINavigationController()
        window!.rootViewController = nav
        nav.pushViewController(Page(), animated: true)
        //        window!.rootViewController = Page()
        window!.rootViewController!.view.backgroundColor = .blue
        window!.makeKeyAndVisible()
        return true
    }
}

class Page : UIViewController{
    var tab:String? = nil
    var currentPage = 0
    var _table :TopicList!
    override func viewDidLoad() {
        _table = TopicList()
        self.view.addSubview(_table)
        _table.snp.makeConstraints{
            $0.top.right.bottom.left.equalTo(view)
        }
        print(view.frame)
        load()
        
    }
    func load() {
        TopicListModel.getTopicList(tab){[weak self](response) -> Void in
            if response.success {
                self?._table?.topicList = response.value
                self?.currentPage = 0
                self?._table.ds = [(self?._table!.topicList!)!]
                self?._table.load()
            }
        }
    }
}
class TopicList : Table {
    var topicList:[TopicListModel]?
    init() {
        super.init(frame: CGRect.zero, style: .plain)// if it is .grouped ,then a blanket line appeared on top of tableview,FUCK
        let _table = self
        _table.cellClass = TopicCell.self
        _table.onCellData = {(cell ,obj) in
            let ds = obj as! TopicListModel
            let c = cell as! TopicCell
            self.loadData(ds,c)
        }
    }
    func loadData(_ model : TopicListModel ,_ cell : TopicCell){
        cell._title.text = model.topicTitle
        if let avata = model.avata {
            cell._avatar.fin_setImageWithUrl(URL(string: "https:" + avata)!, placeholderImage: nil, imageModificationClosure: fin_defaultImageModification() )
        }
        cell._user.text = model.userName;
        if let layout = model.topicTitleLayout {
            // flash is prevented
            if layout.text.string == cell.itemModel?.topicTitleLayout?.text.string {
                return
            }
            else{
                cell._title.textLayout = layout
            }
        }
        if let avata = model.avata {
            cell._avatar.fin_setImageWithUrl(URL(string: "https:" + avata)!, placeholderImage: nil, imageModificationClosure: fin_defaultImageModification() )
        }
        cell._replies.text = model.replies;
        
        cell.itemModel = model
        cell._date.text = model.date
        cell._node.text = model.nodeName
        
    }
    // The code that make compiler happy
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.topicList![indexPath.row]
//        let titleHeight = item.topicTitleLayout?.textBoundingRect.size.height ?? 0
        let titleHeight = item.IamHigh()
        //          上间隔   头像高度  头像下间隔       标题高度    标题下间隔 cell间隔
        let height = 12    +  35     +  12      + titleHeight   + 12      + 8
        
        return height
    }
}
class TopicCell:UITableViewCell{
    override func layoutSubviews(){
        setup()
        setupLayout()
        setupInteraction()
    }
    /// 头像
    var _avatar: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode=UIViewContentMode.scaleAspectFit
        return imageview
    }()
    
    /// 用户名
    var _user: UILabel = {
        let label = UILabel()
        label.font = v2Font(14)
        return label;
    }()
    /// 日期 和 最后发送人
    var _date: UILabel = {
        let label = UILabel()
        label.font=v2Font(12)
        return label
    }()
    /// 评论数量
    var _replies: UILabel = {
        let label = UILabel()
        label.font = v2Font(12)
        return label
    }()
    var _replyIcon: UIImageView = {
        let imageview = UIImageView(image: UIImage(named: "reply_n"))
        imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    
    /// 节点
    var _node: UILabel = {
        let label = UILabel();
        label.font = v2Font(11)
        return label
    }()
    /// 帖子标题
    var _title: YYLabel = {
        let label = YYLabel()
        label.textVerticalAlignment = .top
        label.font=v2Font(18)
        label.displaysAsynchronously = true
        label.numberOfLines=0
        return label
    }()
    
    /// 装上面定义的那些元素的容器
    var contentPanel:UIView = UIView()
    
    var itemModel:TopicListModel?
    
    
    func setup()->Void{
        let selectedBackgroundView = UIView()
        self.selectedBackgroundView = selectedBackgroundView
        
        self.contentView .addSubview(self.contentPanel);
        self.contentPanel.addSubview(self._avatar);
        self.contentPanel.addSubview(self._user);
        self.contentPanel.addSubview(self._date);
        self.contentPanel.addSubview(self._replies);
        self.contentPanel.addSubview(self._replyIcon);
        self.contentPanel.addSubview(self._node)
        self.contentPanel.addSubview(self._title)
        
    }
    func setupInteraction(){
        //点击用户头像，跳转到用户主页
        self._avatar.isUserInteractionEnabled = true
        self._user.isUserInteractionEnabled = true
        var userNameTap = UITapGestureRecognizer(target: self, action: #selector(HomeTopicListTableViewCell.userNameTap(_:)))
        self._avatar.addGestureRecognizer(userNameTap)
        userNameTap = UITapGestureRecognizer(target: self, action: #selector(HomeTopicListTableViewCell.userNameTap(_:)))
        self._user.addGestureRecognizer(userNameTap)
    }
    func layout(_ view : UIView,_ closure: (_ make: ConstraintMaker) -> Void){
        view.snp.makeConstraints(closure)
    }
    fileprivate func setupLayout(){
        self.contentPanel.snp.makeConstraints{
            $0.top.left.right.equalTo(self.contentView);
        }
        self._avatar.snp.makeConstraints{
            $0.left.top.equalTo(self.contentView).offset(12);
            $0.width.height.equalTo(35);
        }
        self._user.snp.makeConstraints{
            $0.left.equalTo(self._avatar.snp.right).offset(10);
            $0.top.equalTo(self._avatar);
        }
        self._date.snp.makeConstraints{
            $0.bottom.equalTo(self._avatar);
            $0.left.equalTo(self._user);
        }
        self._replies.snp.makeConstraints{
            $0.centerY.equalTo(self._user);
            $0.right.equalTo(self.contentPanel).offset(-12);
        }
        self._replyIcon.snp.makeConstraints{
            $0.centerY.equalTo(self._replies);
            $0.width.height.equalTo(18);
            $0.right.equalTo(self._replies.snp.left).offset(-2);
        }
        self._node.snp.makeConstraints{
            $0.centerY.equalTo(self._replies);
            $0.right.equalTo(self._replyIcon.snp.left).offset(-9)
            $0.bottom.equalTo(self._replies).offset(1);
            $0.top.equalTo(self._replies).offset(-1);
        }
        self._title.snp.makeConstraints{
            $0.top.equalTo(self._avatar.snp.bottom).offset(12);
            $0.left.equalTo(self._avatar);
            $0.right.equalTo(self.contentPanel).offset(-12);
            $0.bottom.equalTo(self.contentPanel).offset(-8)
        }
        self.contentPanel.snp.makeConstraints{
            $0.bottom.equalTo(self.contentView.snp.bottom).offset(-8);
        }
    }
    
    func userNameTap(_ sender:UITapGestureRecognizer) {
        //outlets
        //        if let _ = self.itemModel , let username = itemModel?.userName {
        //            let memberViewController = MemberViewController()
        //            memberViewController.username = username
        //            V2Client.sharedInstance.centerNavigation?.pushViewController(memberViewController, animated: true)
        //        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
class TopicListModel:TopicListModel1 {
    var topicTitleAttributedString: NSMutableAttributedString?
    var topicTitleLayout: YYTextLayout?
    override func setupTitleLayout(){
        if let title = self.topicTitle {
            self.topicTitleAttributedString = NSMutableAttributedString(string: title,
                                                                        attributes: [
                                                                            NSFontAttributeName:v2Font(17),
                                                                            NSForegroundColorAttributeName:V2EXColor.colors.v2_TopicListTitleColor,
                                                                            ])
            self.topicTitleAttributedString?.yy_lineSpacing = 3
            self.topicTitleLayout = YYTextLayout(containerSize: CGSize(width: UIScreen.main.bounds.size.width-24, height: 9999), text: topicTitleAttributedString!)
        }
    }
    // IamHigh (self.topicTitle)
    func IamHigh() -> CGFloat{
        return IamHigh(self.topicTitle!)
    }
    func IamHigh(_ title : String) -> CGFloat{
        var topicTitleAttributedString: NSMutableAttributedString?
        var topicTitleLayout: YYTextLayout?
        topicTitleAttributedString = NSMutableAttributedString(string: title,
                                                                        attributes: [
                                                                            NSFontAttributeName:v2Font(17),
                                                                            NSForegroundColorAttributeName:V2EXColor.colors.v2_TopicListTitleColor,
                                                                            ])
        topicTitleAttributedString?.yy_lineSpacing = 3
        topicTitleLayout = YYTextLayout(containerSize: CGSize(width: UIScreen.main.bounds.size.width-24, height: 9999), text: topicTitleAttributedString!)
        //}
        return topicTitleLayout?.textBoundingRect.size.height ?? 0
    }
}
class TopicListModel1:NSObject {
    var topicId: String?
    var avata: String?
    var nodeName: String?
    var userName: String?
    var topicTitle: String?
    
    
    var date: String?
    var lastReplyUserName: String?
    var replies: String?
    
    var hits: String?
    
    override init() {
        super.init()
    }
    init(rootNode: JiNode) {
        super.init()
        
        self.avata = rootNode.xPath("./table/tr/td[1]/a[1]/img[@class='avatar']").first?["src"]
        self.nodeName = rootNode.xPath("./table/tr/td[3]/span[1]/a[1]").first?.content
        self.userName = rootNode.xPath("./table/tr/td[3]/span[1]/strong[1]/a[1]").first?.content
        
        let node = rootNode.xPath("./table/tr/td[3]/span[2]/a[1]").first
        self.topicTitle = node?.content
        self.setupTitleLayout()
        
        var topicIdUrl = node?["href"];
        
        if var id = topicIdUrl {
            if let range = id.range(of: "/t/") {
                id.replaceSubrange(range, with: "");
            }
            if let range = id.range(of: "#") {
                id = id.substring(to: range.lowerBound)
                topicIdUrl = id
            }
        }
        self.topicId = topicIdUrl
        
        
        self.date = rootNode.xPath("./table/tr/td[3]/span[3]").first?.content
        
        var lastReplyUserName:String? = nil
        if let lastReplyUser = rootNode.xPath("./table/tr/td[3]/span[3]/strong[1]/a[1]").first{
            lastReplyUserName = lastReplyUser.content
        }
        self.lastReplyUserName = lastReplyUserName
        
        var replies:String? = nil;
        if let reply = rootNode.xPath("./table/tr/td[4]/a[1]").first {
            replies = reply.content
        }
        self.replies  = replies
        
    }
    init(favoritesRootNode:JiNode) {
        super.init()
        self.avata = favoritesRootNode.xPath("./table/tr/td[1]/a[1]/img[@class='avatar']").first?["src"]
        self.nodeName = favoritesRootNode.xPath("./table/tr/td[3]/span[2]/a[1]").first?.content
        self.userName = favoritesRootNode.xPath("./table/tr/td[3]/span[2]/strong[1]/a").first?.content
        
        let node = favoritesRootNode.xPath("./table/tr/td[3]/span/a[1]").first
        self.topicTitle = node?.content
        self.setupTitleLayout()
        
        var topicIdUrl = node?["href"];
        
        if var id = topicIdUrl {
            if let range = id.range(of: "/t/") {
                id.replaceSubrange(range, with: "");
            }
            if let range = id.range(of: "#") {
                id = id.substring(to: range.lowerBound)
                topicIdUrl = id
            }
        }
        self.topicId = topicIdUrl
        
        
        let date = favoritesRootNode.xPath("./table/tr/td[3]/span[2]").first?.content
        if let date = date {
            let array = date.components(separatedBy: "•")
            if array.count == 4 {
                self.date = array[3].trimmingCharacters(in: NSCharacterSet.whitespaces)
                
            }
        }
        
        self.lastReplyUserName = favoritesRootNode.xPath("./table/tr/td[3]/span[2]/strong[2]/a[1]").first?.content
        
        self.replies = favoritesRootNode.xPath("./table/tr/td[4]/a[1]").first?.content
    }
    
    init(nodeRootNode:JiNode) {
        super.init()
        self.avata = nodeRootNode.xPath("./table/tr/td[1]/a[1]/img[@class='avatar']").first?["src"]
        self.userName = nodeRootNode.xPath("./table/tr/td[3]/span[2]/strong").first?.content
        
        let node = nodeRootNode.xPath("./table/tr/td[3]/span/a[1]").first
        self.topicTitle = node?.content
        self.setupTitleLayout()
        
        var topicIdUrl = node?["href"];
        
        if var id = topicIdUrl {
            if let range = id.range(of: "/t/") {
                id.replaceSubrange(range, with: "");
            }
            if let range = id.range(of: "#") {
                id = id.substring(to: range.lowerBound)
                topicIdUrl = id
            }
        }
        self.topicId = topicIdUrl
        
        
        self.hits = nodeRootNode.xPath("./table/tr/td[3]/span[last()]/text()").first?.content
        if var hits = self.hits {
            hits = hits.substring(from: hits.index(hits.startIndex, offsetBy: 5))
            self.hits = hits
        }
        var replies:String? = nil;
        if let reply = nodeRootNode.xPath("./table/tr/td[4]/a[1]").first {
            replies = reply.content
        }
        self.replies  = replies
    }
    
    func setupTitleLayout(){
    }
}
