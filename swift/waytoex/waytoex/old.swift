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
let kHomeTab = "me.fin.homeTab"

class HomeViewController: UIViewController {
    var topicList:Array<TopicListModel>?
    var tab:String? = nil
    var currentPage = 0
    
    fileprivate var _tableView :UITableView!
    fileprivate var tableView: UITableView {
        get{
            if(_tableView != nil){
                return _tableView!;
            }
            _tableView = UITableView();
            
            _tableView.separatorStyle = UITableViewCellSeparatorStyle.none;
            
            regClass(_tableView, cell: HomeTopicListTableViewCell.self);
            
            _tableView.delegate = self;
            _tableView.dataSource = self;
            return _tableView!;
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title="V2EX";
        self.tab = V2EXSettings.sharedInstance[kHomeTab]
        self.setupNavigationItem()
        
        //监听程序即将进入前台运行、进入后台休眠 事件
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.applicationWillEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.applicationDidEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        
        self.view.addSubview(self.tableView);
        self.tableView.snp.makeConstraints{ (make) -> Void in
            make.top.right.bottom.left.equalTo(self.view);
        }
        self.tableView.mj_header = V2RefreshHeader(refreshingBlock: {[weak self] () -> Void in
            self?.refresh()
        })
        self.refreshPage()
        
        let footer = V2RefreshFooter(refreshingBlock: {[weak self] () -> Void in
            self?.getNextPage()
        })
        footer?.centerOffset = -4
        self.tableView.mj_footer = footer
    }
    func setupNavigationItem(){
        let leftButton = NotificationMenuButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        leftButton.addTarget(self, action: #selector(HomeViewController.leftClick), for: .touchUpInside)
        
        
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightButton.contentMode = .center
        rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15)
        rightButton.setImage(UIImage.imageUsedTemplateMode("ic_more_horiz_36pt")!.withRenderingMode(.alwaysTemplate), for: UIControlState())
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        rightButton.addTarget(self, action: #selector(HomeViewController.rightClick), for: .touchUpInside)
        
    }
    func leftClick(){
        V2Client.sharedInstance.drawerController?.toggleLeftDrawerSide(animated: true, completion: nil)
    }
    func rightClick(){
        V2Client.sharedInstance.drawerController?.toggleRightDrawerSide(animated: true, completion: nil)
    }
    
    func refreshPage(){
        self.tableView.mj_header.beginRefreshing();
        V2EXSettings.sharedInstance[kHomeTab] = tab
    }
    func refresh(){
        
        //如果有上拉加载更多 正在执行，则取消它
        if self.tableView.mj_footer.isRefreshing() {
            self.tableView.mj_footer.endRefreshing()
        }
        
        //根据 tab name 获取帖子列表
        TopicListModel.getTopicList(tab){
            (response) -> Void in
            
            if true {
                
                self.topicList = response
                self.tableView.reloadData()
                
                //判断标签是否能加载下一页, 不能就提示下
                let refreshFooter = self.tableView.mj_footer as! V2RefreshFooter
                if self.tab == nil || self.tab == "all" {
                    refreshFooter.noMoreDataStateString = nil
                    refreshFooter.resetNoMoreData()
                }
                else{
                    refreshFooter.noMoreDataStateString = "没更多帖子了,只有【\(NSLocalizedString("all"))】标签能翻页"
                    refreshFooter.endRefreshingWithNoMoreData()
                }
                
                //重置page
                self.currentPage = 0
                
            }
            self.tableView.mj_header.endRefreshing()
        }
    }
    
    func getNextPage(){
        if let count = self.topicList?.count , count <= 0{
            self.tableView.mj_footer.endRefreshing()
            return;
        }
        //根据 tab name 获取帖子列表
        self.currentPage += 1
        TopicListModel.getTopicList(tab,page: self.currentPage){
            (response:[TopicListModel]) -> Void in
            
            if response.count > 0 {
//                if let count = response.count, count > 0 {
                    self.topicList? += response
                    self.tableView.reloadData()
//                }
            }
            else{
                //加载失败，重置page
                self.currentPage -= 1
            }
            self.tableView.mj_footer.endRefreshing()
        }
    }
    
    static var lastLeaveTime = Date()
    func applicationWillEnterForeground(){
        //计算上次离开的时间与当前时间差
        //如果超过2分钟，则自动刷新本页面。
        let interval = -1 * HomeViewController.lastLeaveTime.timeIntervalSinceNow
        if interval > 120 {
            self.tableView.mj_header.beginRefreshing()
        }
    }
    func applicationDidEnterBackground(){
        HomeViewController.lastLeaveTime = Date()
    }
}


//MARK: - TableViewDataSource
extension HomeViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = self.topicList {
            return list.count;
        }
        return 0;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.topicList![indexPath.row]
        let titleHeight = Foo.OccupyHigh(item.topicTitle!)
        //          上间隔   头像高度  头像下间隔       标题高度    标题下间隔 cell间隔
        let height = 12    +  35     +  12      + titleHeight   + 12      + 8
        
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = getCell(tableView, cell: HomeTopicListTableViewCell.self, indexPath: indexPath);
        cell.bind(self.topicList![indexPath.row]);
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //outlets
    }
    
}

class TopicListModel_:NSObject {
    var topicId: String?
    var avata: String?
    var nodeName: String?
    var userName: String?
    var topicTitle: String?
    var topicTitleAttributedString: NSMutableAttributedString?
    var topicTitleLayout: YYTextLayout?
    
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
        if let title = self.topicTitle {
            self.topicTitleAttributedString = NSMutableAttributedString(string: title,
                                                                        attributes: [
                                                                            NSFontAttributeName:v2Font(17),
                                                                            NSForegroundColorAttributeName:V2EXColor.colors.v2_TopicListTitleColor,
                                                                            ])
            self.topicTitleAttributedString?.yy_lineSpacing = 3
            
            //监听颜色配置文件变化，当有变化时，改变自身颜色
            self.thmemChangedHandler = {[weak self] (style) -> Void in
                if let str = self?.topicTitleAttributedString {
                    str.yy_color = V2EXColor.colors.v2_TopicListTitleColor
                    self?.topicTitleLayout = YYTextLayout(containerSize: CGSize(width: SCREEN_WIDTH-24, height: 9999), text: str)
                }
            }
        }
    }
}

//MARK: - Request
import UIKit


let SCREEN_WIDTH = UIScreen.main.bounds.size.width;
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height;

//用户代理，使用这个切换是获取 m站点 还是www站数据
let USER_AGENT = "Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.3 (KHTML, like Gecko) Version/8.0 Mobile/12A4345d Safari/600.1.4";
let MOBILE_CLIENT_HEADERS = ["user-agent":USER_AGENT]


//站点地址,客户端只有https,禁用http


let SEPARATOR_HEIGHT = 1.0 / UIScreen.main.scale


func NSLocalizedString( _ key:String ) -> String {
    return NSLocalizedString(key, comment: "")
}




func v2Font1(_ fontSize: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: fontSize);
}

func v2ScaleFont(_ fontSize: CGFloat) -> UIFont{
    return v2Font(fontSize * CGFloat(V2Style.sharedInstance.fontScale))
}
//
//  V2User.swift
//  V2ex-Swift
//
//  Created by skyline on 16/3/28.
//  Copyright © 2016年 Fin. All rights reserved.
//
import UIKit
import Alamofire
import Ji

let kUserName = "me.fin.username"

class V2User: NSObject {
    static let sharedInstance = V2User()
    /// 用户信息
    fileprivate var _user:UserModel?
    var user:UserModel? {
        get {
            return self._user
        }
        set {
            //保证给user赋值是在主线程进行的
            //原因是 有很多UI可能会监听这个属性，这个属性发生更改时，那些UI也会相应的修改自己，所以要在主线程操作
            dispatch_sync_safely_main_queue {
                self._user = newValue
                self.username = newValue?.username
            }
        }
    }
    
    dynamic var username:String?
    
    fileprivate var _once:String?
    //全局once字符串，用于用户各种操作，例如回帖 登录 。这些操作都需要用的once ，而且这个once是全局统一的
    var once:String?  {
        get {
            //取了之后就删掉,
            //因为once 只能使用一次，之后就不可再用了，
            let onceStr = _once
            _once = nil
            return onceStr;
        }
        set{
            _once = newValue
        }
    }
    /// 返回 客户端显示是否有可用的once
    var hasOnce:Bool {
        get {
            return _once != nil && _once!.Lenght > 0
        }
    }
    
    /// 通知数量
    dynamic var notificationCount:Int = 0
    
    
    
    fileprivate override init() {
        super.init()
        dispatch_sync_safely_main_queue {
            self.setup()
            //如果客户端是登录状态，则去验证一下登录有没有过期
            if self.isLogin {
                self.verifyLoginStatus()
            }
        }
    }
    func setup(){
        self.username = V2EXSettings.sharedInstance[kUserName]
    }
    
    
    /// 是否登录
    var isLogin:Bool {
        get {
            if let len = self.username?.Lenght , len > 0 {
                return true
            }
            else {
                return false
            }
        }
    }
    
    func ensureLoginWithHandler(_ handler:()->()) {
        guard isLogin else {
            V2Inform("请先登录")
            return;
        }
        handler()
    }
    /**
     退出登录
     */
    func loginOut() {
        removeAllCookies()
        self.user = nil
        self.username = nil
        self.once = nil
        self.notificationCount = 0
        //清空settings中的username
        V2EXSettings.sharedInstance[kUserName] = nil
    }
    
    /**
     删除客户端所有cookies
     */
    func removeAllCookies() {
        let storage = HTTPCookieStorage.shared
        if let cookies = storage.cookies {
            for cookie in cookies {
                storage.deleteCookie(cookie)
            }
        }
    }
    /**
     打印客户端cookies
     */
    func printAllCookies(){
        let storage = HTTPCookieStorage.shared
        if let cookies = storage.cookies {
            for cookie in cookies {
                NSLog("name:%@ , value:%@ \n", cookie.name,cookie.value)
            }
        }
    }
    
    /**
     获取once
     
     - parameter url:               有once存在的url
     */
    func getOnce(_ url:String = V2EXURL+"signin" , completionHandler: @escaping (V2Response) -> Void) {
        Alamofire.request(url, headers: MOBILE_CLIENT_HEADERS).responseJiHtml {
            (response) -> Void in
            if let jiHtml = response .result.value{
                if let once = jiHtml.xPath("//*[@name='once'][1]")?.first?["value"]{
                    self.once = once
                    completionHandler(V2Response(success: true))
                    return;
                }
            }
            completionHandler(V2Response(success: false))
        }
    }
    
    /**
     获取并更新通知数量
     - parameter rootNode: 有Notifications 的节点
     */
    func getNotificationsCount(_ rootNode: JiNode) {
        //这里本想放在 JIHTMLResponseSerializer 自动获取。
        //但我现在还不确定，是否每个每个页面的title都会带上 未读通知数量
        //所以先交由 我确定会带的页面 手动获取
        let notification = rootNode.xPath("//head/title").first?.content
        if let notification = notification {
            
            self.notificationCount = 0;
            
            let regex = try! NSRegularExpression(pattern: "V2EX \\([0-9]+\\)", options: [.caseInsensitive])
            regex.enumerateMatches(in: notification, options: [.withoutAnchoringBounds], range: NSMakeRange(0, notification.Lenght), using: { (result, flags, stop) -> Void in
                if let result = result {
                    let startIndex = notification.index(notification.startIndex, offsetBy: result.range.location + 6)
                    let endIndex = notification.index(notification.startIndex, offsetBy: result.range.location + result.range.length - 1)
                    let count = notification[startIndex..<endIndex]
                    if let acount = Int(count) {
                        self.notificationCount = acount
                    }
                }
            })
        }
    }
    
    /**
     验证客户端登录状态
     
     - returns: ture: 正常登录 ,false: 登录过期，没登录
     */
    func verifyLoginStatus() {
        Alamofire.request(V2EXURL + "new",  headers: MOBILE_CLIENT_HEADERS).responseString(encoding: nil) { (response) -> Void in
            if response.request?.url?.absoluteString == response.response?.url?.absoluteString {
                //登录正常
            }
            else{
                //没有登录 ,注销客户端
                dispatch_sync_safely_main_queue({ () -> () in
                    self.loginOut()
                })
            }
        }
    }
}
//
import UIKit

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

func regClass(_ tableView:UITableView , cell:AnyClass)->Void {
    tableView.register( cell, forCellReuseIdentifier: "\(cell)");
}
func getCell<T: UITableViewCell>(_ tableView:UITableView ,cell: T.Type ,indexPath:IndexPath) -> T {
    return tableView.dequeueReusableCell(withIdentifier: "\(cell)", for: indexPath) as! T ;
}

class HomeTopicListTableViewCell: UITableViewCell {
    override func layoutSubviews(){
        setup()
        setupLayout()
        layout(self.dateAndLastPostUserLabel){
            $0.bottom.equalTo(self.avatarImageView);
            $0.left.equalTo(self.userNameLabel);
        }
    }
    /// 头像
    var avatarImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode=UIViewContentMode.scaleAspectFit
        return imageview
    }()
    
    /// 用户名
    var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = v2Font(14)
        return label;
    }()
    /// 日期 和 最后发送人
    var dateAndLastPostUserLabel: UILabel = {
        let label = UILabel()
        label.font=v2Font(12)
        return label
    }()
    /// 评论数量
    var replyCountLabel: UILabel = {
        let label = UILabel()
        label.font = v2Font(12)
        return label
    }()
    var replyCountIconImageView: UIImageView = {
        let imageview = UIImageView(image: UIImage(named: "reply_n"))
        imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    
    /// 节点
    var nodeNameLabel: UILabel = {
        let label = UILabel();
        label.font = v2Font(11)
        return label
    }()
    var nodeBackgroundImageView:UIImageView = UIImageView()
    /// 帖子标题
    var topicTitleLabel: YYLabel = {
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
        self.contentPanel.addSubview(self.avatarImageView);
        self.contentPanel.addSubview(self.userNameLabel);
        self.contentPanel.addSubview(self.dateAndLastPostUserLabel);
        self.contentPanel.addSubview(self.replyCountLabel);
        self.contentPanel.addSubview(self.replyCountIconImageView);
        self.contentPanel.addSubview(self.nodeBackgroundImageView)
        self.contentPanel.addSubview(self.nodeNameLabel)
        self.contentPanel.addSubview(self.topicTitleLabel);
        //点击用户头像，跳转到用户主页
        self.avatarImageView.isUserInteractionEnabled = true
        self.userNameLabel.isUserInteractionEnabled = true
        var userNameTap = UITapGestureRecognizer(target: self, action: #selector(HomeTopicListTableViewCell.userNameTap(_:)))
        self.avatarImageView.addGestureRecognizer(userNameTap)
        userNameTap = UITapGestureRecognizer(target: self, action: #selector(HomeTopicListTableViewCell.userNameTap(_:)))
        self.userNameLabel.addGestureRecognizer(userNameTap)
        
    }
    
    func layout(_ view : UIView,_ closure: (_ make: ConstraintMaker) -> Void){
        view.snp.makeConstraints(closure)
    }
    fileprivate func setupLayout(){
        self.contentPanel.snp.makeConstraints{ (make) -> Void in
            make.top.left.right.equalTo(self.contentView);
        }
        self.avatarImageView.snp.makeConstraints{ (make) -> Void in
            make.left.top.equalTo(self.contentView).offset(12);
            make.width.height.equalTo(35);
        }
        self.userNameLabel.snp.makeConstraints{ (make) -> Void in
            make.left.equalTo(self.avatarImageView.snp.right).offset(10);
            make.top.equalTo(self.avatarImageView);
        }
        //        self.dateAndLastPostUserLabel.snp.makeConstraints{ (make) -> Void in
        //            make.bottom.equalTo(self.avatarImageView);
        //            make.left.equalTo(self.userNameLabel);
        //        }
        self.replyCountLabel.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalTo(self.userNameLabel);
            make.right.equalTo(self.contentPanel).offset(-12);
        }
        self.replyCountIconImageView.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalTo(self.replyCountLabel);
            make.width.height.equalTo(18);
            make.right.equalTo(self.replyCountLabel.snp.left).offset(-2);
        }
        self.nodeNameLabel.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalTo(self.replyCountLabel);
            make.right.equalTo(self.replyCountIconImageView.snp.left).offset(-9)
            make.bottom.equalTo(self.replyCountLabel).offset(1);
            make.top.equalTo(self.replyCountLabel).offset(-1);
        }
        self.nodeBackgroundImageView.snp.makeConstraints{ (make) -> Void in
            make.top.bottom.equalTo(self.nodeNameLabel)
            make.left.equalTo(self.nodeNameLabel).offset(-5)
            make.right.equalTo(self.nodeNameLabel).offset(5)
        }
        self.topicTitleLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.avatarImageView.snp.bottom).offset(12);
            make.left.equalTo(self.avatarImageView);
            make.right.equalTo(self.contentPanel).offset(-12);
            make.bottom.equalTo(self.contentView).offset(-8)
        }
        self.contentPanel.snp.makeConstraints{ (make) -> Void in
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-8);
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
    
    
    
    func bind(_ model:TopicListModel){
//        self.userNameLabel.text = model.userName;
//        if let layout = model.topicTitleLayout {
//            //如果新旧model标题相同,则不需要赋值
//            //不然layout需要重新绘制，会造成刷新闪烁
//            if layout.text.string == self.itemModel?.topicTitleLayout?.text.string {
//                return
//            }
//            else{
//                self.topicTitleLabel.textLayout = layout
//            }
//        }
//        if let avata = model.avata {
//            self.avatarImageView.fin_setImageWithUrl(URL(string: "https:" + avata)!, placeholderImage: nil, imageModificationClosure: fin_defaultImageModification() )
//        }
//        self.replyCountLabel.text = model.replies;
//        
//        self.itemModel = model
//        self.dateAndLastPostUserLabel.text = model.date
//        self.nodeNameLabel.text = model.nodeName
    }
}





//MARK: - 主题更改时，自动执行
extension NSObject {
    fileprivate struct AssociatedKeys {
        static var thmemChanged = "thmemChanged"
    }
    
    /// 当前主题更改时、第一次设置时 自动调用的闭包
    public typealias ThemeChangedClosure = @convention(block) (_ style:String) -> Void
    
    /// 自动调用的闭包
    /// 设置时，会设置一个KVO监听，当V2Style.style更改时、第一次赋值时 会自动调用这个闭包
    var thmemChangedHandler:ThemeChangedClosure? {
        get {
            let closureObject: AnyObject? = objc_getAssociatedObject(self, &AssociatedKeys.thmemChanged) as AnyObject?
            guard closureObject != nil else{
                return nil
            }
            let closure = unsafeBitCast(closureObject, to: ThemeChangedClosure.self)
            return closure
        }
        set{
            guard let value = newValue else{
                return
            }
            let dealObject: AnyObject = unsafeBitCast(value, to: AnyObject.self)
            objc_setAssociatedObject(self, &AssociatedKeys.thmemChanged,dealObject,objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            //设置KVO监听
            self.kvoController.observe(V2EXColor.sharedInstance, keyPath: "style", options: [.initial,.new] , block: {[weak self] (nav, color, change) -> Void in
                self?.thmemChangedHandler?(V2EXColor.sharedInstance.style)
                }
            )
        }
    }
}
import UIKit
import DrawerController

class V2Client: NSObject {
    static let sharedInstance = V2Client()
    
    var drawerController :DrawerController? = nil
    var centerViewController : HomeViewController? = nil
    var centerNavigation : V2EXNavigationController? = nil
    
    // 当前程序中，最上层的 NavigationController
    var topNavigationController : UINavigationController {
        get{
            return V2Client.getTopNavigationController(V2Client.sharedInstance.centerNavigation!)
        }
    }
    
    fileprivate class func getTopNavigationController(_ currentNavigationController:UINavigationController) -> UINavigationController {
        if let topNav = currentNavigationController.visibleViewController?.navigationController{
            if topNav != currentNavigationController && topNav.isKind(of: UINavigationController.self){
                return getTopNavigationController(topNav)
            }
        }
        return currentNavigationController
    }
}
class V2EXNavigationController: UINavigationController {
    
    /// 毛玻璃效果的 navigationBar 背景
    var frostedView:UIToolbar = UIToolbar()
    /// navigationBar 阴影
    var shadowImage:UIImage?
    /// navigationBar 背景透明度
    var navigationBarAlpha:CGFloat {
        get{
            return  self.frostedView.alpha
        }
        set {
            var value = newValue
            if newValue > 1 {
                value = 1
            }
            else if value < 0 {
                value = 0
            }
            self.frostedView.alpha = newValue
            if(value == 1){
                if self.navigationBar.shadowImage != nil{
                    self.navigationBar.shadowImage = nil
                }
            }
            else {
                if self.navigationBar.shadowImage == nil{
                    self.navigationBar.shadowImage = UIImage()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.setStatusBarStyle(.default, animated: true);
        
        let maskingView = UIView()
        maskingView.isUserInteractionEnabled = false
        maskingView.backgroundColor = UIColor(white: 0, alpha: 0.0);
        self.navigationBar.superview!.insertSubview(maskingView, belowSubview: self.navigationBar)
        maskingView.snp.makeConstraints{ (make) -> Void in
            make.left.bottom.right.equalTo(self.navigationBar)
            make.top.equalTo(self.navigationBar).offset(-20);
        }
        
        self.frostedView.isUserInteractionEnabled = false
        self.frostedView.clipsToBounds = true
        maskingView.addSubview(self.frostedView);
        self.frostedView.snp.makeConstraints{ (make) -> Void in
            make.top.bottom.left.right.equalTo(maskingView);
        }
        
        self.thmemChangedHandler = {[weak self] (style) -> Void in
            self?.navigationBar.tintColor = V2EXColor.colors.v2_navigationBarTintColor
            
            self?.navigationBar.titleTextAttributes = [
                NSFontAttributeName : v2Font(18),
                NSForegroundColorAttributeName : V2EXColor.colors.v2_TopicListTitleColor
            ]
            
            if V2EXColor.sharedInstance.style == V2EXColor.V2EXColorStyleDefault {
                self?.frostedView.barStyle = .default
                UIApplication.shared.setStatusBarStyle(.default, animated: true);
                
                //全局键盘颜色
                UITextView.appearance().keyboardAppearance = .light
                UITextField.appearance().keyboardAppearance = .light
                YYTextView.appearance().keyboardAppearance = .light
                
            }
            else{
                self?.frostedView.barStyle = .black
                UIApplication.shared.setStatusBarStyle(.lightContent, animated: true);
                
                UITextView.appearance().keyboardAppearance = .dark
                UITextField.appearance().keyboardAppearance = .dark
                YYTextView.appearance().keyboardAppearance = .dark
            }
        }
    }
}
class V2RefreshHeader: MJRefreshHeader {
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

class V2RefreshFooter: MJRefreshAutoFooter {
    
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
class NotificationMenuButton: UIButton {
    var aPointImageView:UIImageView?
    required init(){
        super.init(frame: CGRect.zero)
        self.contentMode = .center
        self.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0)
        self.setImage(UIImage.imageUsedTemplateMode("ic_menu_36pt")!, for: UIControlState())
        
        self.aPointImageView = UIImageView()
        self.aPointImageView!.backgroundColor = V2EXColor.colors.v2_NoticePointColor
        self.aPointImageView!.layer.cornerRadius = 4
        self.aPointImageView!.layer.masksToBounds = true
        self.addSubview(self.aPointImageView!)
        self.aPointImageView!.snp.makeConstraints{ (make) -> Void in
            make.width.height.equalTo(8)
            make.top.equalTo(self).offset(3)
            make.right.equalTo(self).offset(-6)
        }
        
        self.kvoController.observe(V2User.sharedInstance, keyPath: "notificationCount", options: [.initial,.new]) {  [weak self](cell, clien, change) -> Void in
            if V2User.sharedInstance.notificationCount > 0 {
                self?.aPointImageView!.isHidden = false
            }
            else{
                self?.aPointImageView!.isHidden = true
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class V2Response: NSObject {
    var success:Bool = false
    var message:String = "No message"
    init(success:Bool,message:String?) {
        super.init()
        self.success = success
        if let message = message{
            self.message = message
        }
    }
    init(success:Bool) {
        super.init()
        self.success = success
    }
}

class V2ValueResponse<T>: V2Response {
    var value:T?
    
    override init(success: Bool) {
        super.init(success: success)
    }
    
    override init(success:Bool,message:String?) {
        super.init(success:success)
        if let message = message {
            self.message = message
        }
    }
    convenience init(value:T,success:Bool) {
        self.init(success: success)
        self.value = value
    }
    convenience init(value:T,success:Bool,message:String?) {
        self.init(value:value,success:success)
        if let message = message {
            self.message = message
        }
    }
}
//
//  UserModel.swift
//  V2ex-Swift
//
//  Created by huangfeng on 1/23/16.
//  Copyright © 2016 Fin. All rights reserved.
//
import UIKit
import Alamofire
import Ji
import ObjectMapper
class BaseJsonModel: Mappable {
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        
    }
}


protocol BaseHtmlModelProtocol {
    init(rootNode:JiNode)
}


class UserModel: BaseJsonModel {
    var status:String?
    var id:String?
    var url:String?
    var username:String?
    var website:String?
    var twitter:String?
    var psn:String?
    var btc:String?
    var location:String?
    var tagline:String?
    var bio:String?
    var avatar_mini:String?
    var avatar_normal:String?
    var avatar_large:String?
    var created:String?
    
    override func mapping(map: Map) {
        status <- map["status"]
        id <- map["id"]
        url <- map["url"]
        username <- map["username"]
        website <- map["website"]
        twitter <- map["twitter"]
        psn <- map["psn"]
        btc <- map["btc"]
        location <- map["location"]
        tagline <- map["tagline"]
        bio <- map["bio"]
        avatar_mini <- map["avatar_mini"]
        avatar_normal <- map["avatar_normal"]
        avatar_large <- map["avatar_large"]
        created <- map["created"]
    }
}

//MARK: - Request
extension UserModel{
    /**
     登录
     
     - parameter username:          用户名
     - parameter password:          密码
     - parameter completionHandler: 登录回调
     */
    class func Login(_ username:String,password:String ,
                     completionHandler: @escaping (_ response:V2ValueResponse<String>, _ is2FALoggedIn:Bool) -> Void
        ) -> Void{
        V2User.sharedInstance.removeAllCookies()
        
        Alamofire.request(V2EXURL+"signin", headers: MOBILE_CLIENT_HEADERS).responseJiHtml{
            (response) -> Void in
            
            if let jiHtml = response .result.value{
                //获取帖子内容
                //取出 once 登录时要用
                
                let onceStr:String? = jiHtml.xPath("//*[@name='once'][1]")?.first?["value"]
                let usernameStr:String? = jiHtml.xPath("//*[@id='Wrapper']/div/div[1]/div[2]/form/table/tr[1]/td[2]/input[@class='sl']")?.first?["name"]
                let passwordStr:String? = jiHtml.xPath("//*[@id='Wrapper']/div/div[1]/div[2]/form/table/tr[2]/td[2]/input[@class='sl']")?.first?["name"]
                
                if let onceStr = onceStr , let usernameStr = usernameStr, let passwordStr = passwordStr {
                    UserModel.Login(username, password: password, once: onceStr, usernameFieldName: usernameStr, passwordFieldName: passwordStr , completionHandler: completionHandler)
                    return;
                }
            }
            completionHandler(V2ValueResponse(success: false,message: "获取 必要字段 失败"),false)
        }
    }
    
    /**
     登录
     
     - parameter username:          用户名
     - parameter password:          密码
     - parameter once:              once
     - parameter completionHandler: 登录回调
     */
    class func Login(_ username:String,password:String ,once:String,
                     usernameFieldName:String ,passwordFieldName:String,
                     completionHandler: @escaping (V2ValueResponse<String>, Bool) -> Void){
        let prames = [
            "once":once,
            "next":"/",
            passwordFieldName:password,
            usernameFieldName:username
        ]
        
        var dict = MOBILE_CLIENT_HEADERS
        //为安全，此处使用https
        dict["Referer"] = "https://v2ex.com/signin"
        //登录
        Alamofire.request(V2EXURL+"signin",method:.post, parameters: prames, headers: dict).responseJiHtml{
            (response) -> Void in
            if let jiHtml = response .result.value{
                //判断有没有用户头像，如果有，则证明登录成功了
                if let avatarImg = jiHtml.xPath("//*[@id='Top']/div/div/table/tr/td[3]/a[1]/img[1]")?.first {
                    if let username = avatarImg.parent?["href"]{
                        if username.hasPrefix("/member/") {
                            let username = username.replacingOccurrences(of: "/member/", with: "")
                            
                            //用户开启了两步验证
                            if let url = response.response?.url?.absoluteString, url.contains("2fa") {
                                completionHandler(V2ValueResponse(value: username, success: true),true)
                            }
                                //登陆完成
                            else{
                                completionHandler(V2ValueResponse(value: username, success: true),false)
                            }
                            return;
                        }
                    }
                }
                
            }
            completionHandler(V2ValueResponse(success: false,message: "登录失败"),false)
        }
    }
    
    class func twoFALogin(code:String,
                          completionHandler: @escaping (Bool) -> Void) {
        V2User.sharedInstance.getOnce { (response) in
            if(response.success){
                let prames = [
                    "code":code,
                    "once":V2User.sharedInstance.once!
                    ] as [String:Any]
                let url = V2EXURL + "2fa"
                Alamofire.request(url, method: .post, parameters: prames, headers: MOBILE_CLIENT_HEADERS).responseJiHtml { (response) -> Void in
                    if(response.result.isSuccess){
                        if let url = response.response?.url?.absoluteString, url.contains("2fa") {
                            completionHandler(false);
                        }
                        else{
                            completionHandler(true);
                        }
                    }
                    else{
                        completionHandler(false);
                    }
                }
            }
            else{
                completionHandler(false);
            }
        }
    }
    
    class func getUserInfoByUsername(_ username:String ,completionHandler:((V2ValueResponse<UserModel>) -> Void)? ){
        let prame = [
            "username":username
        ]
        Alamofire.request(V2EXURL+"api/members/show.json", parameters: prame, headers: MOBILE_CLIENT_HEADERS).responseObject { (response : DataResponse<UserModel>) in
            if let model = response.result.value {
                V2User.sharedInstance.user = model
                
                //将头像更新进 keychain保存的users中
                if let avatar = model.avatar_large {
                    V2UsersKeychain.sharedInstance.update(username, password: nil, avatar: "https:" + avatar )
                }
                
                completionHandler?(V2ValueResponse(value: model, success: true))
                return ;
            }
            completionHandler?(V2ValueResponse(success: false,message: "获取用户信息失败"))
        }
    }
    
    
    class func dailyRedeem() {
        V2User.sharedInstance.getOnce { (response) -> Void in
            if response.success {
                Alamofire.request(V2EXURL + "mission/daily/redeem?once=" + V2User.sharedInstance.once! , headers: MOBILE_CLIENT_HEADERS).responseJiHtml{ (response) in
                    if let jiHtml = response .result.value{
                        if let aRootNode = jiHtml.xPath("//*[@id='Wrapper']/div/div/div[@class='message']")?.first {
                            if aRootNode.content == "已成功领取每日登录奖励" {
                                print("每日登录奖励 领取成功")
                                dispatch_sync_safely_main_queue({ () -> () in
                                    V2Inform("已成功领取每日登录奖励")
                                })
                            }
                        }
                        
                    }
                }
                
            }
        }
    }
    
}
//
//  V2Style.swift
//  V2ex-Swift
//
//  Created by huangfeng on 3/10/16.
//  Copyright © 2016 Fin. All rights reserved.
//
import UIKit
//CSS基本样式
private let BASE_CSS = try! String(contentsOfFile: Bundle.main.path(forResource: "baseStyle", ofType: "css")!, encoding: String.Encoding.utf8)
//文字大小
private let FONT_CSS = try! String(contentsOfFile: Bundle.main.path(forResource: "font", ofType: "css")!, encoding: String.Encoding.utf8)
//暗色主题配色
private let DARK_CSS = (try! String(contentsOfFile: Bundle.main.path(forResource: "darkStyle", ofType: "css")!, encoding: String.Encoding.utf8))
//亮色主题配色
private let LIGHT_CSS = (try! String(contentsOfFile: Bundle.main.path(forResource: "lightStyle", ofType: "css")!, encoding: String.Encoding.utf8))


private let kFONTSCALE = "kFontScale"

/// 自动维护APP的CSS文件 ,外界只需调用 V2Style.sharedInstance.CSS 即可取得APP所需要的CSS
class V2Style: NSObject {
    static let sharedInstance = V2Style()
    
    fileprivate var _fontScale:Float = 1.0
    dynamic var fontScale:Float {
        get{
            return _fontScale
        }
        set{
            if _fontScale != newValue {
                _fontScale = newValue
                self.remakeCSS()
                V2EXSettings.sharedInstance[kFONTSCALE] = "\(_fontScale)"
            }
        }
    }
    var CSS = ""
    
    fileprivate override init() {
        super.init()
        //加载字体大小设置
        if let fontScaleString = V2EXSettings.sharedInstance[kFONTSCALE] , let scale = Float(fontScaleString){
            self._fontScale = scale
        }
        //监听主题配色，切换相应的配色
        self.thmemChangedHandler = {[weak self] (style) -> Void in
            self?.remakeCSS()
        }
        
    }
    
    //重新拼接CSS字符串
    fileprivate func remakeCSS(){
        if let _ = V2EXColor.colors as? V2EXDefaultColor {
            self.CSS = BASE_CSS + self.fontCss() + LIGHT_CSS
        }
        else{
            self.CSS = BASE_CSS + self.fontCss() + DARK_CSS
        }
    }
    
    /**
     获取 FONT_CSS
     */
    fileprivate func fontCss() -> String {
        var fontCss = FONT_CSS
        
        //替换FONT_SIZE
        FONT_SIZE_ARRAY.forEach { (fontSize) -> () in
            fontCss = fontCss.replacingOccurrences(of: fontSize.labelName, with:String(fontSize.defaultFontSize * fontScale))
        }
        
        return fontCss
    }
}




let FONT_SIZE_ARRAY = [
    V2FontSize(labelName:"<H1_FONT_SIZE>",defaultFontSize:18),
    V2FontSize(labelName:"<H2_FONT_SIZE>",defaultFontSize:18),
    V2FontSize(labelName:"<H3_FONT_SIZE>",defaultFontSize:16),
    V2FontSize(labelName:"<PRE_FONT_SIZE>",defaultFontSize:13),
    V2FontSize(labelName:"<BODY_FONT_SIZE>",defaultFontSize:14),
    V2FontSize(labelName:"<SUBTLE_FONT_SIZE>",defaultFontSize:12),
    V2FontSize(labelName:"<SUBTLE_FADE_FONT_SIZE>",defaultFontSize:10),
]

struct V2FontSize {
    let labelName:String
    let defaultFontSize:Float
}

class V2UsersKeychain {
    static let sharedInstance = V2UsersKeychain()
    fileprivate let keychain = KeychainSwift()
    
    fileprivate(set) var users:[String:LocalSecurityAccountModel] = [:]
    
    fileprivate init() {
        let _ = loadUsersDict()
    }
    
    func addUser(_ user:LocalSecurityAccountModel){
        if let username = user.username , let _ = user.password {
            self.users[username] = user
            self.saveUsersDict()
        }
        else {
            assert(false, "username & password must not be 'nil'")
        }
    }
    func addUser(_ username:String,password:String,avata:String? = nil) {
        let user = LocalSecurityAccountModel()
        user.username = username
        user.password = password
        user.avatar = avata
        self.addUser(user)
    }
    
    static let usersKey = "me.fin.testDict"
    func saveUsersDict(){
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(self.users)
        archiver.finishEncoding()
        keychain.set(data as Data, forKey: V2UsersKeychain.usersKey);
    }
    func loadUsersDict() -> [String:LocalSecurityAccountModel]{
        if users.count <= 0 {
            let data = keychain.getData(V2UsersKeychain.usersKey)
            if let data = data{
                let archiver = NSKeyedUnarchiver(forReadingWith: data)
                let usersDict = archiver.decodeObject()
                archiver.finishDecoding()
                if let usersDict = usersDict as? [String : LocalSecurityAccountModel] {
                    self.users = usersDict
                }
            }
        }
        return self.users
    }
    
    func removeUser(_ username:String){
        self.users.removeValue(forKey: username)
        self.saveUsersDict()
    }
    func removeAll(){
        self.users = [:]
        self.saveUsersDict()
    }
    
    func update(_ username:String,password:String? = nil,avatar:String? = nil){
        if let user = self.users[username] {
            if let password = password {
                user.password = password
            }
            if let avatar = avatar {
                user.avatar = avatar
            }
            self.saveUsersDict()
        }
    }
    
}


/// 将会序列化后保存进keychain中的 账户model
class LocalSecurityAccountModel :NSObject, NSCoding {
    var username:String?
    var password:String?
    var avatar:String?
    override init(){
        
    }
    required init?(coder aDecoder: NSCoder){
        self.username = aDecoder.decodeObject(forKey: "username") as? String
        self.password = aDecoder.decodeObject(forKey: "password") as? String
        self.avatar = aDecoder.decodeObject(forKey: "avatar") as? String
    }
    func encode(with aCoder: NSCoder){
        aCoder.encode(self.username, forKey: "username")
        aCoder.encode(self.password, forKey: "password")
        aCoder.encode(self.avatar, forKey: "avatar")
    }
}

import SVProgressHUD

open class V2ProgressHUD: NSObject {
    open class func show() {
        SVProgressHUD.show(with: .none)
    }
    
    open class func showWithClearMask() {
        SVProgressHUD.show(with: .clear)
    }
    
    open class func dismiss() {
        SVProgressHUD.dismiss()
    }
    
    open class func showWithStatus(_ status:String!) {
        SVProgressHUD.show(withStatus: status)
    }
    
    open class func success(_ status:String!) {
        SVProgressHUD.showSuccess(withStatus: status)
    }
    
    open class func error(_ status:String!) {
        SVProgressHUD.showError(withStatus: status)
    }
    
    open class func inform(_ status:String!) {
        SVProgressHUD.showInfo(withStatus: status)
    }
}

public func V2Success(_ status:String!) {
    V2ProgressHUD.success(status)
}

public func V2Error(_ status:String!) {
    V2ProgressHUD.error(status)
}

public func V2Inform(_ status:String!) {
    V2ProgressHUD.inform(status)
}

public func V2BeginLoading() {
    V2ProgressHUD.show()
}

public func V2BeginLoadingWithStatus(_ status:String!) {
    V2ProgressHUD.showWithStatus(status)
}

public func V2EndLoading() {
    V2ProgressHUD.dismiss()
}

