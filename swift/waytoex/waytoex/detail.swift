
import UIKit
//
//  V2LoadingView.swift
//  V2ex-Swift
//
//  Created by huangfeng on 1/28/16.
//  Copyright © 2016 Fin. All rights reserved.
//

import UIKit

let noticeString = [
    "正在拼命加载",
    "前方发现楼主",
    "年轻人,不要着急",
    "让我飞一会儿",
    "大爷,您又来了?",
    "楼主正在抓皮卡丘，等他一会儿吧",
    "爱我，就等我一万年",
    "未满18禁止入内",
    "正在前往 花村",
    "正在前往 阿努比斯神殿",
    "正在前往 沃斯卡娅工业区",
    "正在前往 观测站：直布罗陀",
    "正在前往 好莱坞",
    "正在前往 66号公路",
    "正在前往 国王大道",
    "正在前往 伊利奥斯",
    "正在前往 漓江塔",
    "正在前往 尼泊尔"
]

class V2LoadingView: UIView {
    var activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    init (){
        super.init(frame:CGRect.zero)
        self.addSubview(self.activityIndicatorView)
        self.activityIndicatorView.snp.makeConstraints{ (make) -> Void in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-32)
        }
        
        let noticeLabel = UILabel()
        //修复BUG。做个小笔记给阅读代码的兄弟们提个醒
        //(Int)(arc4random())
        //上面这种写法有问题，arc4random()会返回 一个Uint32的随机数值。
        //在32位机器上,如果随机的数大于Int.max ,转换就会crash。
        noticeLabel.text = noticeString[Int(arc4random() % UInt32(noticeString.count))]
        noticeLabel.font = v2Font(10)
        noticeLabel.textColor = V2EXColor.colors.v2_TopicListDateColor
        self.addSubview(noticeLabel)
        noticeLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.activityIndicatorView.snp.bottom).offset(10)
            make.centerX.equalTo(self.activityIndicatorView)
        }
        
        
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        self.activityIndicatorView.startAnimating()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hide(){
        self.superview?.bringSubview(toFront: self)
        
        UIView.animate(withDuration: 0.2,
                       animations: { () -> Void in
                        self.alpha = 0 ;
        }, completion: { (finished) -> Void in
            if finished {
                self.removeFromSuperview();
            }
        })
        
    }
}
class BaseViewController: UIViewController {
    fileprivate weak var _loadView:V2LoadingView?
    
    func showLoadingView (){
        
        self.hideLoadingView()
        
        let aloadView = V2LoadingView()
        aloadView.backgroundColor = self.view.backgroundColor
        self.view.addSubview(aloadView)
        aloadView.snp.makeConstraints{ (make) -> Void in
            make.top.right.bottom.left.equalTo(self.view)
        }
        self._loadView = aloadView
    }
    
    func hideLoadingView() {
        self._loadView?.removeFromSuperview()
    }
    
}

class TopicDetailViewController: BaseViewController{
    
    var topicId = "0"
    var currentPage = 1
    
    fileprivate var model:TopicDetailModel?
    fileprivate var commentsArray:[TopicCommentModel] = []
    fileprivate var webViewContentCell:TopicDetailWebViewContentCell?
    
    fileprivate var _tableView :UITableView!
    fileprivate var tableView: UITableView {
        get{
            if(_tableView != nil){
                return _tableView!;
            }
            _tableView = UITableView();
            _tableView.separatorStyle = UITableViewCellSeparatorStyle.none;
            
            _tableView.backgroundColor = V2EXColor.colors.v2_backgroundColor
            regClass(_tableView, cell: TopicDetailHeaderCell.self)
            regClass(_tableView, cell: TopicDetailWebViewContentCell.self)
            regClass(_tableView, cell: TopicDetailCommentCell.self)
            regClass(_tableView, cell: BaseDetailTableViewCell.self)
            
            _tableView.delegate = self
            _tableView.dataSource = self
            return _tableView!;
            
        }
    }
    /// 忽略帖子成功后 ，调用的闭包
    var ignoreTopicHandler : ((String) -> Void)?
    //点击右上角more按钮后，弹出的 activityView
    //只在activityView 显示在屏幕上持有它，如果activityView释放了，这里也一起释放。
    fileprivate weak var activityView:V2ActivityViewController?
    
    //MARK: - 页面事件
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ("postDetails")
        self.view.backgroundColor = V2EXColor.colors.v2_backgroundColor
        self.view.addSubview(self.tableView);
        self.tableView.snp.makeConstraints{ (make) -> Void in
            make.top.right.bottom.left.equalTo(self.view);
        }
        
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightButton.contentMode = .center
        rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15)
        rightButton.setImage(UIImage(named: "ic_more_horiz_36pt")!.withRenderingMode(.alwaysTemplate), for: UIControlState())
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        rightButton.addTarget(self, action: #selector(TopicDetailViewController.rightClick), for: .touchUpInside)
        
        
        self.showLoadingView()
        self.getData()
        
        self.tableView.mj_header = V2RefreshHeader(refreshingBlock: {[weak self] in
            self?.getData()
        })
        self.tableView.mj_footer = V2RefreshFooter(refreshingBlock: {[weak self] in
            self?.getNextPage()
        })
    }
    
    func getData(){
        //根据 topicId 获取 帖子信息 、回复。
        TopicDetailModel.getTopicDetailById(self.topicId){
            (response:V2ValueResponse<(TopicDetailModel?,[TopicCommentModel])>) -> Void in
            if response.success {
                
                if let aModel = response.value!.0{
                    self.model = aModel
                }
                
                self.commentsArray = response.value!.1
                
                self.currentPage = 1
                
                //清除将帖子内容cell,因为这是个缓存，如果赋值后，就会cache到这个变量，之后直接读这个变量不重新赋值。
                //这里刷新了，则可能需要更新帖子内容cell ,实际上只是重新调用了 cell.load(_:)方法
                self.webViewContentCell = nil
                
                self.tableView.reloadData()
                
            }
            else{
                V2Error("刷新失败");
            }
            if self.tableView.mj_header.isRefreshing(){
                self.tableView.mj_header.endRefreshing()
            }
            self.tableView.mj_footer.resetNoMoreData()
            self.hideLoadingView()
        }
    }
    
    /**
     点击右上角 more 按钮
     */
    func rightClick(){
        if  self.model != nil {
            let activityView = V2ActivityViewController()
            activityView.dataSource = self
            self.navigationController!.present(activityView, animated: true, completion: nil)
            self.activityView = activityView
        }
    }
    /**
     点击节点
     */
    func nodeClick() {
//        let node = NodeModel()
//        node.nodeId = self.model?.node
//        node.nodeName = self.model?.nodeName
//        let controller = NodeTopicListViewController()
//        controller.node = node
//        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    /**
     获取下一页评论，如果有的话
     */
    func getNextPage(){
        if self.model == nil || self.commentsArray.count <= 0 {
            self.endRefreshingWithNoDataAtAll()
            return;
        }
        self.currentPage += 1
        
        if self.model == nil || self.currentPage > self.model!.commentTotalPages {
            self.endRefreshingWithNoMoreData()
            return;
        }
        
        TopicDetailModel.getTopicCommentsById(self.topicId, page: self.currentPage) { (response) -> Void in
            if response.success {
                self.commentsArray += response.value!
                self.tableView.reloadData()
                self.tableView.mj_footer.endRefreshing()
                
                if self.currentPage == self.model?.commentTotalPages {
                    self.endRefreshingWithNoMoreData()
                }
            }
            else{
                self.currentPage -= 1
            }
        }
    }
    
    /**
     禁用上拉加载更多，并显示一个字符串提醒
     */
    func endRefreshingWithStateString(_ string:String){
        (self.tableView.mj_footer as! V2RefreshFooter).noMoreDataStateString = string
        self.tableView.mj_footer.endRefreshingWithNoMoreData()
    }
    
    func endRefreshingWithNoDataAtAll() {
        self.endRefreshingWithStateString("暂无评论")
    }
    
    func endRefreshingWithNoMoreData() {
        self.endRefreshingWithStateString("没有更多评论了")
    }
}



//MARK: - UITableView DataSource
enum TopicDetailTableViewSection: Int {
    case header = 0, comment, other
}

enum TopicDetailHeaderComponent: Int {
    case title = 0,  webViewContent, other
}

extension TopicDetailViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let _section = TopicDetailTableViewSection(rawValue: section)!
        switch _section {
        case .header:
            if self.model != nil{
                return 3
            }
            else{
                return 0
            }
        case .comment:
            return self.commentsArray.count;
        case .other:
            return 0;
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let _section = TopicDetailTableViewSection(rawValue: indexPath.section)!
        var _headerComponent = TopicDetailHeaderComponent.other
        if let headerComponent = TopicDetailHeaderComponent(rawValue: indexPath.row) {
            _headerComponent = headerComponent
        }
        switch _section {
        case .header:
            switch _headerComponent {
            case .title:
                return tableView.fin_heightForCellWithIdentifier(TopicDetailHeaderCell.self, indexPath: indexPath) { (cell) -> Void in
                    cell.bind(self.model!);
                }
            case .webViewContent:
                if let height =  self.webViewContentCell?.contentHeight , height > 0 {
                    return self.webViewContentCell!.contentHeight
                }
                else {
                    return 1
                }
            case .other:
                return 45
            }
        case .comment:
            let layout = self.commentsArray[indexPath.row].textLayout!
            return layout.textBoundingRect.size.height + 12 + 35 + 12 + 12 + 1
        case .other:
            return 200
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let _section = TopicDetailTableViewSection(rawValue: indexPath.section)!
        var _headerComponent = TopicDetailHeaderComponent.other
        if let headerComponent = TopicDetailHeaderComponent(rawValue: indexPath.row) {
            _headerComponent = headerComponent
        }
        
        switch _section {
        case .header:
            switch _headerComponent {
            case .title:
                //帖子标题
                let cell = getCell(tableView, cell: TopicDetailHeaderCell.self, indexPath: indexPath);
                if(cell.nodeClickHandler == nil){
                    cell.nodeClickHandler = {[weak self] () -> Void in
                        self?.nodeClick()
                    }
                }
                cell.bind(self.model!);
                return cell;
            case .webViewContent:
                //帖子内容
                if self.webViewContentCell == nil {
                    self.webViewContentCell = getCell(tableView, cell: TopicDetailWebViewContentCell.self, indexPath: indexPath);
                    self.webViewContentCell?.parentScrollView = self.tableView
                }
                else {
                    return self.webViewContentCell!
                }
                self.webViewContentCell!.load(self.model!);
                if self.webViewContentCell!.contentHeightChanged == nil {
                    self.webViewContentCell!.contentHeightChanged = { [weak self] (height:CGFloat) -> Void  in
                        if let weakSelf = self {
                            //在cell显示在屏幕时更新，否则会崩溃会崩溃会崩溃
                            //另外刷新清空旧cell,重新创建这个cell ,所以 contentHeightChanged 需要判断cell是否为nil
                            if let cell = weakSelf.webViewContentCell, weakSelf.tableView.visibleCells.contains(cell) {
                                if let height = weakSelf.webViewContentCell?.contentHeight, height > 1.5 * SCREEN_HEIGHT{ //太长了就别动画了。。
                                    UIView.animate(withDuration: 0, animations: { () -> Void in
                                        self?.tableView.beginUpdates()
                                        self?.tableView.endUpdates()
                                    })
                                }
                                else {
                                    self?.tableView.beginUpdates()
                                    self?.tableView.endUpdates()
                                }
                            }
                        }
                    }
                }
                return self.webViewContentCell!
            case .other:
                let cell = getCell(tableView, cell: BaseDetailTableViewCell.self, indexPath: indexPath)
                cell.detailMarkHidden = true
                cell.titleLabel.text = self.model?.topicCommentTotalCount
                cell.titleLabel.font = v2Font(12)
                cell.backgroundColor = V2EXColor.colors.v2_CellWhiteBackgroundColor
                cell.separator.image = createImageWithColor(self.view.backgroundColor!)
                return cell
            }
        case .comment:
            let cell = getCell(tableView, cell: TopicDetailCommentCell.self, indexPath: indexPath)
            cell.bind(self.commentsArray[indexPath.row])
            return cell
        case .other:
            return UITableViewCell();
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            self.selectedRowWithActionSheet(indexPath)
        }
    }
}




//MARK: - actionSheet
extension TopicDetailViewController: UIActionSheetDelegate {
    func selectedRowWithActionSheet(_ indexPath:IndexPath){
        self.tableView.deselectRow(at: indexPath, animated: true);
        
        //这段代码也可以执行，但是当点击时，会有个0.3秒的dismiss动画。
        //然后再弹出回复页面或者查看对话页面。感觉太长了，暂时不用
        //        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        //        let replyAction = UIAlertAction(title: "回复", style: .Default) { _ in
        //            self.replyComment(indexPath.row)
        //        }
        //        let thankAction = UIAlertAction(title: "感谢", style: .Default) { _ in
        //            self.thankComment(indexPath.row)
        //        }
        //        let relevantCommentsAction = UIAlertAction(title: "查看对话", style: .Default) { _ in
        //            self.relevantComment(indexPath.row)
        //        }
        //        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        //        //将action全加进actionSheet
        //        [replyAction,thankAction,relevantCommentsAction,cancelAction].forEach { (action) -> () in
        //            actionSheet.addAction(action)
        //        }
        //        self.navigationController?.presentViewController(actionSheet, animated: true, completion: nil)
        
        //这段代码在iOS8.3中弃用，但是现在还可以使用，先用着吧
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "回复", "感谢" ,"查看对话")
        actionSheet.tag = indexPath.row
        actionSheet.show(in: self.view)
        
    }
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if buttonIndex > 0 && buttonIndex <= 3 {
            self.perform([#selector(TopicDetailViewController.replyComment(_:)),#selector(TopicDetailViewController.thankComment(_:)),#selector(TopicDetailViewController.relevantComment(_:))][buttonIndex - 1], with: actionSheet.tag)
        }
    }
    func replyComment(_ row:NSNumber){
//        V2User.sharedInstance.ensureLoginWithHandler {
//            let item = self.commentsArray[row as Int]
//            let replyViewController = ReplyingViewController()
//            replyViewController.atSomeone = "@" + item.userName! + " "
//            replyViewController.topicModel = self.model!
//            let nav = V2EXNavigationController(rootViewController:replyViewController)
//            self.navigationController?.present(nav, animated: true, completion:nil)
//        }
    }
    func thankComment(_ row:NSNumber){
//        guard V2User.sharedInstance.isLogin else {
//            V2Inform("请先登录")
//            return;
//        }
//        let item = self.commentsArray[row as Int]
//        if item.replyId == nil {
//            V2Error("回复replyId为空")
//            return;
//        }
//        if self.model?.token == nil {
//            V2Error("帖子token为空")
//            return;
//        }
//        item.favorites += 1
//        self.tableView.reloadRows(at: [IndexPath(row: row as Int, section: 1)], with: .none)
//        
//        TopicCommentModel.replyThankWithReplyId(item.replyId!, token: self.model!.token!) {
//            [weak item, weak self](response) in
//            if response.success {
//            }
//            else{
//                V2Error("感谢失败了")
//                //失败后 取消增加的数量
//                item?.favorites -= 1
//                self?.tableView.reloadRows(at: [IndexPath(row: row as Int, section: 1)], with: .none)
//            }
//        }
    }
    func relevantComment(_ row:NSNumber){
//        let item = self.commentsArray[row as Int]
//        let relevantComments = TopicCommentModel.getRelevantCommentsInArray(self.commentsArray, firstComment: item)
//        if relevantComments.count <= 0 {
//            return;
//        }
//        let controller = RelevantCommentsNav(comments: relevantComments)
//        self.present(controller, animated: true, completion: nil)
    }
}



//MARK: - V2ActivityView
enum V2ActivityViewTopicDetailAction : Int {
    case block = 0, favorite, grade, explore
}

extension TopicDetailViewController: V2ActivityViewDataSource {
    func V2ActivityView(_ activityView: V2ActivityViewController, numberOfCellsInSection section: Int) -> Int {
        return 4
    }
    func V2ActivityView(_ activityView: V2ActivityViewController, ActivityAtIndexPath indexPath: IndexPath) -> V2Activity {
        return V2Activity(title: [
            NSLocalizedString("ignore"),
            NSLocalizedString("favorite"),
            NSLocalizedString("thank"),
            "Safari"][indexPath.row], image: UIImage(named: ["ic_block_48pt","ic_grade_48pt","ic_favorite_48pt","ic_explore_48pt"][indexPath.row])!)
    }
    func V2ActivityView(_ activityView:V2ActivityViewController ,heightForFooterInSection section: Int) -> CGFloat{
        return 45
    }
    func V2ActivityView(_ activityView:V2ActivityViewController ,viewForFooterInSection section: Int) ->UIView?{
        let view = UIView()
        view.backgroundColor = V2EXColor.colors.v2_ButtonBackgroundColor
        
        let label = UILabel()
        label.font = v2Font(18)
        label.text = NSLocalizedString("reply2")
        label.textAlignment = .center
        label.textColor = UIColor.white
        view.addSubview(label)
        label.snp.makeConstraints{ (make) -> Void in
            make.top.right.bottom.left.equalTo(view)
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TopicDetailViewController.reply)))
        
        return view
    }
    
    func V2ActivityView(_ activityView: V2ActivityViewController, didSelectRowAtIndexPath indexPath: IndexPath) {
//        activityView.dismiss()
//        let action = V2ActivityViewTopicDetailAction(rawValue: indexPath.row)!
//        
//        guard V2User.sharedInstance.isLogin
//            // 用safari打开是不用登录的
//            || action == V2ActivityViewTopicDetailAction.explore else {
//                V2Inform("请先登录")
//                return;
//        }
//        switch action {
//        case .block:
//            V2BeginLoading()
//            if let topicId = self.model?.topicId  {
//                TopicDetailModel.ignoreTopicWithTopicId(topicId, completionHandler: {[weak self] (response) -> Void in
//                    if response.success {
//                        V2Success("忽略成功")
//                        self?.navigationController?.popViewController(animated: true)
//                        self?.ignoreTopicHandler?(topicId)
//                    }
//                    else{
//                        V2Error("忽略失败")
//                    }
//                })
//            }
//        case .favorite:
//            V2BeginLoading()
//            if let topicId = self.model?.topicId ,let token = self.model?.token {
//                TopicDetailModel.favoriteTopicWithTopicId(topicId, token: token, completionHandler: { (response) -> Void in
//                    if response.success {
//                        V2Success("收藏成功")
//                    }
//                    else{
//                        V2Error("收藏失败")
//                    }
//                })
//            }
//        case .grade:
//            V2BeginLoading()
//            if let topicId = self.model?.topicId ,let token = self.model?.token {
//                TopicDetailModel.topicThankWithTopicId(topicId, token: token, completionHandler: { (response) -> Void in
//                    if response.success {
//                        V2Success("成功送了一波铜币")
//                    }
//                    else{
//                        V2Error("没感谢成功，再试一下吧")
//                    }
//                })
//            }
//        case .explore:
//            UIApplication.shared.openURL(URL(string: V2EXURL + "t/" + self.model!.topicId!)!)
//        }
    }
    
    func reply(){
//        self.activityView?.dismiss()
//        V2User.sharedInstance.ensureLoginWithHandler {
//            let replyViewController = ReplyingViewController()
//            replyViewController.topicModel = self.model!
//            let nav = V2EXNavigationController(rootViewController:replyViewController)
//            self.navigationController?.present(nav, animated: true, completion:nil)
//        }
    }
    
}
//
//  TopicDetailModel.swift
//  V2ex-Swift
//
//  Created by huangfeng on 1/16/16.
//  Copyright © 2016 Fin. All rights reserved.
//
protocol BaseHtmlModelProtocol {
    init(rootNode:JiNode)
}

import UIKit

import Alamofire
import Ji
import YYText
import Kingfisher
class TopicDetailModel:NSObject,BaseHtmlModelProtocol {
    var topicId:String?
    
    var avata: String?
    var nodeName: String?
    var node: String?
    
    var userName: String?
    
    var topicTitle: String?
    var topicContent: String?
    var date: String?
    var favorites: String?
    
    var topicCommentTotalCount: String?
    
    var token:String?
    
    var commentTotalPages:Int = 1
    
    override init() {
        
    }
    required init(rootNode: JiNode) {
        let node = rootNode.xPath("./div[1]/a[2]").first
        self.nodeName = node?.content
        
        let nodeUrl = node?["href"]
        let index = nodeUrl?.range(of: "/", options: .backwards, range: nil, locale: nil)
        self.node = nodeUrl?.substring(from: index!.upperBound)
        
        self.avata = rootNode.xPath("./div[1]/div[1]/a/img").first?["src"]
        
        self.userName = rootNode.xPath("./div[1]/small/a").first?.content
        
        self.topicTitle = rootNode.xPath("./div[1]/h1").first?.content
        
        self.topicContent = rootNode.xPath("./div[@class='cell']/div").first?.rawContent
        if self.topicContent == nil {
            self.topicContent = ""
        }
        // Append
        let appendNodes = rootNode.xPath("./div[@class='subtle']") ;
        
        for node in appendNodes {
            if let content =  node.rawContent {
                self.topicContent! += content
            }
        }
        
        
        self.date = rootNode.xPath("./div[1]/small/text()[2]").first?.content
        
        self.favorites = rootNode.xPath("./div[3]/div/span").first?.content
        
        let token = rootNode.xPath("div/div/a[@class='op'][1]").first?["href"]
        if let token = token {
            let array = token.components(separatedBy: "?t=")
            if array.count == 2 {
                self.token = array[1]
            }
        }
    }
}


//MARK: -  Request
extension TopicDetailModel {
    class func getTopicDetailById(
        _ topicId: String,
        completionHandler: @escaping (V2ValueResponse<(TopicDetailModel?,[TopicCommentModel])>) -> Void
        )->Void{
        
        let url = V2EXURL + "t/" + topicId + "?p=1"
        Alamofire.request(url, headers: MOBILE_CLIENT_HEADERS).responseJiHtml { (response) -> Void in
            var topicModel: TopicDetailModel? = nil
            var topicCommentsArray : [TopicCommentModel] = []
            if  let jiHtml = response.result.value {
                //获取帖子内容
                if let aRootNode = jiHtml.xPath("//*[@id='Wrapper']/div/div[1]")?.first{
                    topicModel = TopicDetailModel(rootNode: aRootNode);
                    topicModel?.topicId = topicId
                }
                
                //获取评论
                if let aRootNode = jiHtml.xPath("//*[@id='Wrapper']/div/div[@class='box'][2]/div[attribute::id]"){
                    for aNode in aRootNode {
                        topicCommentsArray.append(TopicCommentModel(rootNode: aNode))
                    }
                }
                
                //获取评论总数
                if let commentTotalCount = jiHtml.xPath("//*[@id='Wrapper']/div/div[3]/div[1]/span") {
                    topicModel?.topicCommentTotalCount = commentTotalCount.first?.content
                }
                
                //获取页数总数
                if let commentTotalPages = jiHtml.xPath("//*[@id='Wrapper']/div/div[@class='box'][2]/div[last()]/a[last()]")?.first?.content {
                    if let pages = Int(commentTotalPages) {
                        topicModel?.commentTotalPages = pages
                    }
                }
                
                //更新通知数量
//                V2User.sharedInstance.getNotificationsCount(jiHtml.rootNode!)
            }
            
            let t = V2ValueResponse<(TopicDetailModel?,[TopicCommentModel])>(value:(topicModel,topicCommentsArray), success: response.result.isSuccess)
            
            completionHandler(t);
        }
    }
    
    class func getTopicCommentsById(
        _ topicId: String,
        page:Int,
        completionHandler: @escaping (V2ValueResponse<[TopicCommentModel]>) -> Void
        ) {
        let url = V2EXURL + "t/" + topicId + "?p=\(page)"
        Alamofire.request(url, headers: MOBILE_CLIENT_HEADERS).responseJiHtml { (response) -> Void in
            var topicCommentsArray : [TopicCommentModel] = []
            if  let jiHtml = response.result.value {
                //获取评论
                if let aRootNode = jiHtml.xPath("//*[@id='Wrapper']/div/div[@class='box'][2]/div[attribute::id]"){
                    for aNode in aRootNode {
                        topicCommentsArray.append(TopicCommentModel(rootNode: aNode))
                    }
                }
                
            }
            let t = V2ValueResponse(value: topicCommentsArray, success: response.result.isSuccess)
            completionHandler(t);
        }
    }
    
    /**
     感谢主题
     */
    class func topicThankWithTopicId(_ topicId:String , token:String ,completionHandler: @escaping (V2Response) -> Void) {
        let url  = V2EXURL + "thank/topic/" + topicId + "?t=" + token
        Alamofire.request(url, method: .post, headers: MOBILE_CLIENT_HEADERS).responseString { (response: DataResponse<String>) -> Void in
            if response.result.isSuccess {
                if let result = response.result.value {
                    if result.Lenght == 0 {
                        completionHandler(V2Response(success: true))
                        return;
                    }
                }
            }
            completionHandler(V2Response(success: false))
        }
    }
    
    /**
     收藏主题
     */
    class func favoriteTopicWithTopicId(_ topicId:String , token:String ,completionHandler: @escaping (V2Response) -> Void) {
        let url  = V2EXURL + "favorite/topic/" + topicId + "?t=" + token
        Alamofire.request(url, headers: MOBILE_CLIENT_HEADERS).responseString { (response: DataResponse<String>) -> Void in
            if response.result.isSuccess {
                completionHandler(V2Response(success: true))
            }
            else{
                completionHandler(V2Response(success: false))
            }
        }
    }
    /**
     忽略主题
     */
    class func ignoreTopicWithTopicId(_ topicId:String ,completionHandler: @escaping (V2Response) -> Void) {
        
//        V2User.sharedInstance.getOnce { (response) -> Void in
//            if response.success ,let once = V2User.sharedInstance.once {
//                let url  = V2EXURL + "ignore/topic/" + topicId + "?once=" + once
//                Alamofire.request(url, headers: MOBILE_CLIENT_HEADERS).responseString { (response: DataResponse<String>) -> Void in
//                    if response.result.isSuccess {
//                        completionHandler(V2Response(success: true))
//                        return
//                    }
//                    else{
//                        completionHandler(V2Response(success: false))
//                    }
//                }
//            }
//            else{
//                completionHandler(V2Response(success: false))
//            }
//        }
    }
    
}

//
//  TopicCommentModel.swift
//  V2ex-Swift
//
//  Created by huangfeng on 3/24/16.
//  Copyright © 2016 Fin. All rights reserved.
//

import UIKit

import Alamofire
import Ji
import YYText
import Kingfisher

protocol V2CommentAttachmentImageTapDelegate : class {
    func V2CommentAttachmentImageSingleTap(_ imageView:V2CommentAttachmentImage)
}
/// 评论中的图片
class V2CommentAttachmentImage:AnimatedImageView {
    /// 父容器中第几张图片
    var index:Int = 0
    
    /// 图片地址
    var imageURL:String?
    
    weak var delegate : V2CommentAttachmentImageTapDelegate?
    
    init(){
        super.init(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        self.autoPlayAnimatedImage = false;
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        self.isUserInteractionEnabled = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if self.image != nil {
            return
        }
        if  let imageURL = self.imageURL , let URL = URL(string: imageURL) {
            self.kf.setImage(with: URL, placeholder: nil, options: nil, completionHandler: { (image, error, cacheType, imageURL) -> () in
                if let image = image {
                    if image.size.width < 80 && image.size.height < 80 {
                        self.contentMode = .bottomLeft
                    }
                }
            })
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let tapCount = touch?.tapCount
        if let tapCount = tapCount {
            if tapCount == 1 {
                self.handleSingleTap(touch!)
            }
        }
        //取消后续的事件响应
        self.next?.touchesCancelled(touches, with: event)
    }
    func handleSingleTap(_ touch:UITouch){
        self.delegate?.V2CommentAttachmentImageSingleTap(self)
    }
}


class TopicCommentModel: NSObject,BaseHtmlModelProtocol {
    var replyId:String?
    var avata: String?
    var userName: String?
    var date: String?
    var comment: String?
    var favorites: Int = 0
    var textLayout:YYTextLayout?
    var images:NSMutableArray = NSMutableArray()
    //楼层
    var number:Int = 0
    
    var textAttributedString:NSMutableAttributedString?
    required init(rootNode: JiNode) {
        super.init()
        
        let id = rootNode.xPath("table/tr/td[3]/div[1]/div[attribute::id]").first?["id"]
        if let id = id {
            if id.hasPrefix("thank_area_") {
                self.replyId = id.replacingOccurrences(of: "thank_area_", with: "")
            }
        }
        
        self.avata = rootNode.xPath("table/tr/td[1]/img").first?["src"]
        
        self.userName = rootNode.xPath("table/tr/td[3]/strong/a").first?.content
        
        self.date = rootNode.xPath("table/tr/td[3]/span").first?.content
        
        if let str = rootNode.xPath("table/tr/td[3]/div[@class='fr']/span").first?.content  , let no =  Int(str){
            self.number = no;
        }
        
        if let favorite = rootNode.xPath("table/tr/td[3]/span[2]").first?.content {
            let array = favorite.components(separatedBy: " ")
            if array.count == 2 {
                if let i = Int(array[1]){
                    self.favorites = i
                }
            }
        }
        
        //构造评论内容
        let commentAttributedString:NSMutableAttributedString = NSMutableAttributedString(string: "")
        let nodes = rootNode.xPath("table/tr/td[3]/div[@class='reply_content']/node()")
        self.preformAttributedString(commentAttributedString, nodes: nodes)
        let textContainer = YYTextContainer(size: CGSize(width: SCREEN_WIDTH - 24, height: 9999))
        self.textLayout = YYTextLayout(container: textContainer, text: commentAttributedString)
        
        self.textAttributedString = commentAttributedString
    }
    func preformAttributedString(_ commentAttributedString:NSMutableAttributedString,nodes:[JiNode]) {
        for element in nodes {
            
            if element.name == "text" , let content = element.content{//普通文本
                commentAttributedString.append(NSMutableAttributedString(string: content,attributes: [NSFontAttributeName:v2ScaleFont(14) , NSForegroundColorAttributeName:V2EXColor.colors.v2_TopicListTitleColor]))
                commentAttributedString.yy_lineSpacing = 5
            }
                
                
            else if element.name == "img" ,let imageURL = element["src"]  {//图片
                let image = V2CommentAttachmentImage()
                image.imageURL = imageURL
                let imageAttributedString = NSMutableAttributedString.yy_attachmentString(withContent: image, contentMode: .scaleAspectFit , attachmentSize: CGSize(width: 80,height: 80), alignTo: v2ScaleFont(14), alignment: .bottom)
                
                commentAttributedString.append(imageAttributedString)
                
                image.index = self.images.count
                self.images.add(imageURL)
            }
                
                
            else if element.name == "a" ,let content = element.content,let url = element["href"]{//超链接
                //递归处理所有子节点,主要是处理下 a标签下包含的img标签
                let subNodes = element.xPath("./node()")
                if subNodes.first?.name != "text" && subNodes.count > 0 {
                    self.preformAttributedString(commentAttributedString, nodes: subNodes)
                }
                if content.Lenght > 0 {
                    let attr = NSMutableAttributedString(string: content ,attributes: [NSFontAttributeName:v2ScaleFont(14)])
                    attr.yy_setTextHighlight(NSMakeRange(0, content.Lenght),
                                             color: V2EXColor.colors.v2_LinkColor,
                                             backgroundColor: UIColor(white: 0.95, alpha: 1),
                                             userInfo: ["url":url],
                                             tapAction: { (view, text, range, rect) -> Void in
                                                if let highlight = text.yy_attribute(YYTextHighlightAttributeName, at: UInt(range.location)) ,let url = (highlight as AnyObject).userInfo["url"] as? String  {
                                                    AnalyzeURLHelper.Analyze(url)
                                                }
                                                
                    }, longPressAction: nil)
                    commentAttributedString.append(attr)
                }
            }
                
                
            else if let content = element.content{//其他
                commentAttributedString.append(NSMutableAttributedString(string: content,attributes: [NSForegroundColorAttributeName:V2EXColor.colors.v2_TopicListTitleColor]))
            }
        }
    }
}

//MARK: - Request
extension TopicCommentModel {
    class func replyWithTopicId(_ topic:TopicDetailModel, content:String,
                                completionHandler: @escaping (V2Response) -> Void){
        let url = V2EXURL + "t/" + topic.topicId!
        
        V2User.sharedInstance.getOnce(url) { (response) -> Void in
            if response.success {
                let prames = [
                    "content":content,
                    "once":V2User.sharedInstance.once!
                    ] as [String:Any]
                
                Alamofire.request(url, method: .post, parameters: prames, headers: MOBILE_CLIENT_HEADERS).responseJiHtml { (response) -> Void in
                    if let location = response.response?.allHeaderFields["Etag"] as? String{
                        if location.Lenght > 0 {
                            completionHandler(V2Response(success: true))
                        }
                        else {
                            completionHandler(V2Response(success: false, message: "回帖失败"))
                        }
                        
                        //不管成功还是失败，更新一下once
                        if let jiHtml = response .result.value{
                            V2User.sharedInstance.once = jiHtml.xPath("//*[@name='once'][1]")?.first?["value"]
                        }
                        return
                    }
                    completionHandler(V2Response(success: false,message: "请求失败"))
                }
            }
            else{
                completionHandler(V2Response(success: false,message: "获取once失败，请重试"))
            }
        }
    }
    
    class func replyThankWithReplyId(_ replyId:String , token:String ,completionHandler: @escaping (V2Response) -> Void) {
        let url  = V2EXURL + "thank/reply/" + replyId + "?t=" + token
        Alamofire.request(url, method: .post, headers: MOBILE_CLIENT_HEADERS).responseString { (response: DataResponse<String>) -> Void in
            if response.result.isSuccess {
                if let result = response.result.value {
                    if result.Lenght == 0 {
                        completionHandler(V2Response(success: true))
                        return;
                    }
                }
            }
            completionHandler(V2Response(success: false))
        }
    }
}


//MARK: - Method
extension TopicCommentModel {
    /**
     用某一条评论，获取和这条评论有关的所有评论
     
     - parameter array: 所有的评论数组
     - parameter firstComment: 这条评论
     
     - returns: 某一条评论相关的评论，里面包含它自己
     */
    class func getRelevantCommentsInArray(_ allCommentsArray:[TopicCommentModel], firstComment:TopicCommentModel) -> [TopicCommentModel] {
        
        var relevantComments:[TopicCommentModel] = []
        
        var users = getUsersOfComment(firstComment)
        users.insert(firstComment.userName!)
        
        for comment in allCommentsArray {
            
            //判断评论中是否只@了其他用户，是的话则证明这条评论是和别人讲的，不属于当前对话
            let commentUsers = getUsersOfComment(comment)
            let intersectUsers = commentUsers.intersection(users)
            if commentUsers.count > 0 && intersectUsers.count <= 0 {
                continue;
            }
            
            if let username = comment.userName {
                if users.contains(username) {
                    relevantComments.append(comment)
                }
            }
            //只找到点击的位置，之后就不找了
            if comment == firstComment {
                break;
            }
        }
        
        return relevantComments
    }
    
    //获取评论中 @ 了多少用户
    class func getUsersOfComment(_ comment:TopicCommentModel) -> Set<String>  {
        
        //获取到所有YYTextHighlight ，用以之后获取 这条评论@了多少用户
        var textHighlights:[YYTextHighlight] = []
        comment.textAttributedString!.enumerateAttribute(YYTextHighlightAttributeName, in: NSMakeRange(0, comment.textAttributedString!.length), options: []) { (attribute, range, stop) -> Void in
            if let highlight = attribute as? YYTextHighlight {
                textHighlights.append(highlight)
            }
        }
        
        //获取这条评论 @ 了多少用户
        var users:Set<String> = []
        for highlight in textHighlights {
            if let url = highlight.userInfo?["url"] as? String{
                let result = AnalyzURLResultType(url: url)
                if case .member(let member) = result {
                    users.insert(member.username)
                }
            }
        }
        
        return users
    }
}
//
//  TopicDetailWebViewContentCell.swift
//  V2ex-Swift
//
//  Created by huangfeng on 1/19/16.
//  Copyright © 2016 Fin. All rights reserved.
//

import UIKit
import KVOController
import JavaScriptCore
import Kingfisher

/**
 * 由于这里的逻辑比较分散，但又缺一不可，所以在这里说明一下
 * 1. 将V站帖子的HTML和此APP内置的CSS等拼接起来，然后用 UIWebView 加载。以实现富文本功能
 * 2. UIWebView 图片请求会被 WebViewImageProtocol 拦截，然后被 Kingfisher 缓存
 * 3. 点击UIWebView 图片时 ，会被内置的 tapGesture 捕获到（这个手势只在 UIWebView 所在的 UITableView 的pan手势 失效时触发
 *    也就是 在没滚动的时候才能点图片（交互优化）
 * 4. 然后通过 JSTools.js内置的 js方法，取得 图片 src,通过内置图片浏览器打开
 */

public typealias TopicDetailWebViewContentHeightChanged = (CGFloat) -> Void

let HTMLHEADER  = "<html><head><meta name=\"viewport\" content=\"width=device-width, user-scalable=no\">"
let jsCode = try! String(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "JSTools", ofType: "js")!))
class TopicDetailWebViewContentCell: UITableViewCell ,UIWebViewDelegate {
    
    fileprivate var model:TopicDetailModel?
    
    var contentHeight : CGFloat = 0
    var contentWebView:UIWebView = {
        let contentWebView = UIWebView()
        contentWebView.isOpaque = false
        contentWebView.backgroundColor = UIColor.clear
        contentWebView.scrollView.isScrollEnabled = false
        contentWebView.scalesPageToFit = false
        return contentWebView
        
    }()
    var contentHeightChanged : TopicDetailWebViewContentHeightChanged?
    
    var tapGesture:UITapGestureRecognizer?
    weak var parentScrollView:UIScrollView?{
        didSet{
            //滑动的时候，点击不生效
            tapGesture?.require(toFail: self.parentScrollView!.panGestureRecognizer)
        }
    }
    var tapImageInfo:TapImageInfo?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.setup();
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setup()->Void{
        self.clipsToBounds = true
        
        self.contentWebView.delegate = self
        self.contentView.addSubview(self.contentWebView);
        self.contentWebView.snp.makeConstraints{ (make) -> Void in
            make.left.top.right.bottom.equalTo(self.contentView)
        }
        
        //强制将 UIWebView 设置背景颜色
        //不然不管怎么设置背景颜色，这B一直是白色，非得我治治他
        for view in self.contentWebView.scrollView.subviews {
            view.backgroundColor = V2EXColor.colors.v2_CellWhiteBackgroundColor
        }
        
        self.kvoController.observe(self.contentWebView.scrollView, keyPath: "contentSize", options: [.new]) {
            [weak self] (observe, observer, change) -> Void in
            if let weakSelf = self {
                let size = change["new"] as! NSValue
                weakSelf.contentHeight = size.cgSizeValue.height;
                weakSelf.contentHeightChanged?(weakSelf.contentHeight)
            }
        }
        
        tapGesture = UITapGestureRecognizer(target: self, action:#selector(TopicDetailWebViewContentCell.tapHandler(_:)))
        self.tapGesture!.delegate = self
        self.contentWebView.addGestureRecognizer(self.tapGesture!);
    }
    func tapHandler(_ tap :UITapGestureRecognizer){
        let tapPoint = tap.location(in: tap.view)
        
        let script = String(format: "getHTMLElementAtPoint(%i,%i)", Int(tapPoint.x),Int(tapPoint.y))
        
        let imgSrc = self.contentWebView.stringByEvaluatingJavaScript(from: script)
        guard let img = imgSrc , img.Lenght > 0 else {
            return
        }
        let arr = img.components(separatedBy: ",")
        guard arr.count == 5 else {
            return;
        }
        let url = fixUrl(url: arr[0])
        let width = Int(arr[1])
        let height = Int(arr[2])
        let left = Int(arr[3])
        let top = Int(arr[4])
        guard let w = width ,let h = height , let l = left , let t = top else {
            return;
        }
        
        self.tapImageInfo = TapImageInfo(url: url, width: w, height: h, left: l, top: t)
        
        let photoBrowser = V2PhotoBrowser(delegate: self)
        photoBrowser.currentPageIndex = 0;
        V2Client.sharedInstance.topNavigationController.present(photoBrowser, animated: true, completion: nil)
        
    }
    private func fixUrl(url:String) -> String {
        if(url.hasPrefix("http") || url.hasPrefix("https")){
            return url
        }
        if (url.hasPrefix("//")){
            return "https:" + url
        }
        else if(url.hasPrefix("/")){
            return "https://www.v2ex.com" + url
        }
        else {
            return url
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func load(_ model:TopicDetailModel){
        if self.model == model{
            return;
        }
        self.model = model
        
        if var html = model.topicContent {
            
            let style = "<style>" + V2Style.sharedInstance.CSS + "</style></head>"
            html =  HTMLHEADER + style  + html + "</html>"
            
            self.contentWebView.loadHTMLString(html, baseURL: URL(string: "https://"))
            
            //这里有一个问题，
            
            //如果baseURL 设置为nil，则可以直接引用本地css文件。
            //但不能加载 地址 //:开头的 的图片。
            
            //如果将baseUrl 设为 http/https ，则可以加载图片。但是却不能直接引用本地css文件，
            //因为WebView 有同源限制，http/https 与 我们本地css文件的 file:// 是不同源的
            //所以就会导致 css 样式不能加载
            
            //所以这里做个了折中方案，baseUrl 使用https ,将css样式写进html。
        }
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        //如果加载的是 自己load 的本地页面 则肯定放过啊
        if navigationType == .other {
            return true
        }
        else if navigationType == .linkClicked {
            if let url = request.url?.absoluteString{
                return !AnalyzeURLHelper.Analyze(url)
            }
        }
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.contentWebView.stringByEvaluatingJavaScript(from: jsCode)
    }
}

//MARK: - 点击图片放大
extension TopicDetailWebViewContentCell : V2PhotoBrowserDelegate {
    //V2PhotoBrowser Delegate
    func numberOfPhotosInPhotoBrowser(_ photoBrowser: V2PhotoBrowser) -> Int {
        return 1
    }
    func photoAtIndexInPhotoBrowser(_ photoBrowser: V2PhotoBrowser, index: Int) -> V2Photo {
        let photo = V2Photo(url: URL(string: self.tapImageInfo!.url)!)
        return photo
    }
    func guideContentModeInPhotoBrowser(_ photoBrowser: V2PhotoBrowser, index: Int) -> UIViewContentMode {
        return .scaleAspectFit
    }
    func guideFrameInPhotoBrowser(_ photoBrowser: V2PhotoBrowser, index: Int) -> CGRect {
        let location = self.contentWebView.convert(self.contentWebView.bounds, to: UIApplication.shared.keyWindow!)
        return CGRect(x: tapImageInfo!.left + Int(location.origin.x), y: tapImageInfo!.top + Int(location.origin.y), width: tapImageInfo!.width, height: tapImageInfo!.height)
    }
    func guideImageInPhotoBrowser(_ photoBrowser: V2PhotoBrowser, index: Int) -> UIImage? {
        var image = KingfisherManager.shared.cache.retrieveImageInMemoryCache(forKey: URL(string:tapImageInfo!.url)!.cacheKey)
        if image == nil {
            image = KingfisherManager.shared.cache.retrieveImageInDiskCache(forKey: URL(string:tapImageInfo!.url)!.cacheKey)
        }
        return image
    }
}

extension TopicDetailWebViewContentCell {
    //让点击图片手势 和webView的手势能共存
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

struct TapImageInfo {
    let url:String
    let width:Int
    let height:Int
    let left:Int
    let top:Int
}
//
//  UITableView+Extension.swift
//  V2ex-Swift
//
//  Created by huangfeng on 1/8/16.
//  Copyright © 2016 Fin. All rights reserved.
//

import UIKit

extension String {
    public var Lenght:Int {
        get{
            return self.characters.count;
        }
    }
}


/**
 向tableView 注册 UITableViewCell
 
 - parameter tableView: tableView
 - parameter cell:      要注册的类名
 */
func regClass(_ tableView:UITableView , cell:AnyClass)->Void {
    tableView.register( cell, forCellReuseIdentifier: "\(cell)");
}
/**
 从tableView缓存中取出对应类型的Cell
 如果缓存中没有，则重新创建一个
 
 - parameter tableView: tableView
 - parameter cell:      要返回的Cell类型
 - parameter indexPath: 位置
 
 - returns: 传入Cell类型的 实例对象
 */
func getCell<T: UITableViewCell>(_ tableView:UITableView ,cell: T.Type ,indexPath:IndexPath) -> T {
    return tableView.dequeueReusableCell(withIdentifier: "\(cell)", for: indexPath) as! T ;
}
//
//  TopicDetailHeaderCell.swift
//  V2ex-Swift
//
//  Created by huangfeng on 1/18/16.
//  Copyright © 2016 Fin. All rights reserved.
//

import UIKit

class TopicDetailHeaderCell: UITableViewCell {
    /// 头像
    var avatarImageView: UIImageView = {
        let imageview = UIImageView();
        imageview.contentMode=UIViewContentMode.scaleAspectFit;
        imageview.layer.cornerRadius = 3;
        imageview.layer.masksToBounds = true;
        return imageview
    }()
    /// 用户名
    var userNameLabel: UILabel = {
        let label = UILabel();
        label.textColor = V2EXColor.colors.v2_TopicListUserNameColor;
        label.font=v2Font(14);
        return label
    }()
    /// 日期 和 最后发送人
    var dateAndLastPostUserLabel: UILabel = {
        let label = UILabel();
        label.textColor=V2EXColor.colors.v2_TopicListDateColor;
        label.font=v2Font(12);
        return label
    }()
    
    /// 节点
    var nodeNameLabel: UILabel = {
        let label = UILabel();
        label.textColor = V2EXColor.colors.v2_TopicListDateColor
        label.font = v2Font(11)
        label.backgroundColor = V2EXColor.colors.v2_NodeBackgroundColor
        label.layer.cornerRadius=2;
        label.clipsToBounds = true
        label.isUserInteractionEnabled = true
        return label
    }()
    
    /// 帖子标题
    var topicTitleLabel: UILabel = {
        let label = V2SpacingLabel();
        label.textColor = V2EXColor.colors.v2_TopicListTitleColor;
        label.font = v2Font(17);
        label.numberOfLines = 0;
        label.preferredMaxLayoutWidth = SCREEN_WIDTH-24;
        return label
    }()
    
    /// 装上面定义的那些元素的容器
    var contentPanel:UIView = {
        let view = UIView()
        view.backgroundColor = V2EXColor.colors.v2_CellWhiteBackgroundColor
        return view
    }()
    
    weak var itemModel:TopicDetailModel?
    var nodeClickHandler:(() -> Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.setup();
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setup()->Void{
        self.selectionStyle = .none
        self.backgroundColor=V2EXColor.colors.v2_backgroundColor;
        
        self.contentView.addSubview(self.contentPanel);
        self.contentPanel.addSubview(self.avatarImageView);
        self.contentPanel.addSubview(self.userNameLabel);
        self.contentPanel.addSubview(self.dateAndLastPostUserLabel);
        self.contentPanel.addSubview(self.nodeNameLabel)
        self.contentPanel.addSubview(self.topicTitleLabel);
        
        self.setupLayout()
        
        //点击用户头像，跳转到用户主页
        self.avatarImageView.isUserInteractionEnabled = true
        self.userNameLabel.isUserInteractionEnabled = true
        var userNameTap = UITapGestureRecognizer(target: self, action: #selector(TopicDetailHeaderCell.userNameTap(_:)))
        self.avatarImageView.addGestureRecognizer(userNameTap)
        userNameTap = UITapGestureRecognizer(target: self, action: #selector(TopicDetailHeaderCell.userNameTap(_:)))
        self.userNameLabel.addGestureRecognizer(userNameTap)
        self.nodeNameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nodeClick)))
        
    }
    
    fileprivate func setupLayout(){
        self.avatarImageView.snp.makeConstraints{ (make) -> Void in
            make.left.top.equalTo(self.contentPanel).offset(12);
            make.width.height.equalTo(35);
        }
        self.userNameLabel.snp.makeConstraints{ (make) -> Void in
            make.left.equalTo(self.avatarImageView.snp.right).offset(10);
            make.top.equalTo(self.avatarImageView);
        }
        self.dateAndLastPostUserLabel.snp.makeConstraints{ (make) -> Void in
            make.bottom.equalTo(self.avatarImageView);
            make.left.equalTo(self.userNameLabel);
        }
        self.nodeNameLabel.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalTo(self.userNameLabel);
            make.right.equalTo(self.contentPanel.snp.right).offset(-10)
            make.bottom.equalTo(self.userNameLabel).offset(1);
            make.top.equalTo(self.userNameLabel).offset(-1);
        }
        self.topicTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.avatarImageView.snp.bottom).offset(12);
            make.left.equalTo(self.avatarImageView);
            make.right.equalTo(self.contentPanel).offset(-12);
        }
        self.contentPanel.snp.makeConstraints{ (make) -> Void in
            make.top.left.right.equalTo(self.contentView);
            make.bottom.equalTo(self.topicTitleLabel.snp.bottom).offset(12);
            make.bottom.equalTo(self.contentView).offset(SEPARATOR_HEIGHT * -1);
        }
    }
    func nodeClick() {
        nodeClickHandler?()
    }
    func userNameTap(_ sender:UITapGestureRecognizer) {
        if let _ = self.itemModel , let username = itemModel?.userName {
            let memberViewController = MemberViewController()
            memberViewController.username = username
            V2Client.sharedInstance.centerNavigation?.pushViewController(memberViewController, animated: true)
        }
    }
    
    func bind(_ model:TopicDetailModel){
        
        self.itemModel = model
        
        self.userNameLabel.text = model.userName;
        self.dateAndLastPostUserLabel.text = model.date
        self.topicTitleLabel.text = model.topicTitle;
        
        if let avata = model.avata {
            self.avatarImageView.fin_setImageWithUrl(URL(string: "https:" + avata)!, placeholderImage: nil, imageModificationClosure: fin_defaultImageModification())
        }
        
        if let node = model.nodeName{
            self.nodeNameLabel.text = "  " + node + "  "
        }
    }
}
//
//  TopicDetailCommentCell.swift
//  V2ex-Swift
//
//  Created by huangfeng on 1/20/16.
//  Copyright © 2016 Fin. All rights reserved.
//

import UIKit
import YYText

class TopicDetailCommentCell: UITableViewCell{
    /// 头像
    var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.contentMode=UIViewContentMode.scaleAspectFit
        avatarImageView.layer.cornerRadius = 3
        avatarImageView.layer.masksToBounds = true
        return avatarImageView
    }()
    /// 用户名
    var userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.textColor = V2EXColor.colors.v2_TopicListUserNameColor
        userNameLabel.font=v2Font(14)
        return userNameLabel
    }()
    /// 日期 和 最后发送人
    var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.textColor=V2EXColor.colors.v2_TopicListDateColor
        dateLabel.font=v2Font(12)
        return dateLabel
    }()
    
    /// 回复正文
    var commentLabel: YYLabel = {
        let commentLabel = YYLabel();
        commentLabel.textColor=V2EXColor.colors.v2_TopicListTitleColor;
        commentLabel.font = v2Font(14);
        commentLabel.numberOfLines = 0;
        commentLabel.displaysAsynchronously = true
        return commentLabel
    }()
    
    /// 装上面定义的那些元素的容器
    var contentPanel: UIView = {
        let view = UIView()
        view.backgroundColor = V2EXColor.colors.v2_CellWhiteBackgroundColor
        return view
    }()
    
    //评论喜欢数
    var favoriteIconView:UIImageView = {
        let favoriteIconView = UIImageView(image: UIImage.imageUsedTemplateMode("ic_favorite_18pt")!)
        favoriteIconView.tintColor = V2EXColor.colors.v2_TopicListDateColor;
        favoriteIconView.contentMode = .scaleAspectFit
        favoriteIconView.isHidden = true
        return favoriteIconView
    }()
    
    var favoriteLabel:UILabel = {
        let favoriteLabel = UILabel()
        favoriteLabel.textColor = V2EXColor.colors.v2_TopicListDateColor;
        favoriteLabel.font = v2Font(10)
        return favoriteLabel
    }()
    var itemModel:TopicCommentModel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.setup();
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup()->Void{
        self.backgroundColor=V2EXColor.colors.v2_backgroundColor;
        
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = V2EXColor.colors.v2_backgroundColor
        self.selectedBackgroundView = selectedBackgroundView
        
        self.contentView.addSubview(self.contentPanel);
        self.contentPanel.addSubview(self.avatarImageView);
        self.contentPanel .addSubview(self.userNameLabel);
        self.contentPanel.addSubview(self.favoriteIconView)
        self.contentPanel.addSubview(self.favoriteLabel)
        self.contentPanel.addSubview(self.dateLabel);
        self.contentPanel.addSubview(self.commentLabel);
        
        self.setupLayout()
        
        self.avatarImageView.backgroundColor = self.contentPanel.backgroundColor
        self.userNameLabel.backgroundColor = self.contentPanel.backgroundColor
        self.dateLabel.backgroundColor = self.contentPanel.backgroundColor
        self.commentLabel.backgroundColor = self.contentPanel.backgroundColor
        self.favoriteIconView.backgroundColor = self.contentPanel.backgroundColor
        self.favoriteLabel.backgroundColor = self.contentPanel.backgroundColor
        
        //点击用户头像，跳转到用户主页
        self.avatarImageView.isUserInteractionEnabled = true
        self.userNameLabel.isUserInteractionEnabled = true
        var userNameTap = UITapGestureRecognizer(target: self, action: #selector(TopicDetailCommentCell.userNameTap(_:)))
        self.avatarImageView.addGestureRecognizer(userNameTap)
        userNameTap = UITapGestureRecognizer(target: self, action: #selector(TopicDetailCommentCell.userNameTap(_:)))
        self.userNameLabel.addGestureRecognizer(userNameTap)
        
        //长按手势
        self.contentView .addGestureRecognizer(
            UILongPressGestureRecognizer(target: self,
                                         action: #selector(TopicDetailCommentCell.longPressHandle(_:))
            )
        )
    }
    func setupLayout(){
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
        self.favoriteIconView.snp.makeConstraints{ (make) -> Void in
            make.centerY.equalTo(self.userNameLabel);
            make.left.equalTo(self.userNameLabel.snp.right).offset(10)
            make.width.height.equalTo(10)
        }
        self.favoriteLabel.snp.makeConstraints{ (make) -> Void in
            make.left.equalTo(self.favoriteIconView.snp.right).offset(3)
            make.centerY.equalTo(self.favoriteIconView)
        }
        self.dateLabel.snp.makeConstraints{ (make) -> Void in
            make.bottom.equalTo(self.avatarImageView);
            make.left.equalTo(self.userNameLabel);
        }
        self.commentLabel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.avatarImageView.snp.bottom).offset(12);
            make.left.equalTo(self.avatarImageView);
            make.right.equalTo(self.contentPanel).offset(-12);
            make.bottom.equalTo(self.contentPanel.snp.bottom).offset(-12)
        }
        
        self.contentPanel.snp.makeConstraints{ (make) -> Void in
            make.bottom.equalTo(self.contentView.snp.bottom).offset(-SEPARATOR_HEIGHT);
        }
    }
    func userNameTap(_ sender:UITapGestureRecognizer) {
        if let _ = self.itemModel , let username = itemModel?.userName {
            let memberViewController = MemberViewController()
            memberViewController.username = username
            V2Client.sharedInstance.topNavigationController.pushViewController(memberViewController, animated: true)
        }
    }
    func bind(_ model:TopicCommentModel){
        
        if let avata = model.avata {
            self.avatarImageView.fin_setImageWithUrl(URL(string: "https:" + avata)!, placeholderImage: nil, imageModificationClosure: fin_defaultImageModification())
        }
        
        if self.itemModel?.number == model.number && self.itemModel?.userName == model.userName {
            return;
        }
        
        self.userNameLabel.text = model.userName;
        self.dateLabel.text = String(format: "%i楼  %@", model.number, model.date ?? "")
        
        if let layout = model.textLayout {
            self.commentLabel.textLayout = layout
            if layout.attachments != nil {
                for attachment in layout.attachments! {
                    if let image = attachment.content as? V2CommentAttachmentImage{
                        image.delegate = self
                    }
                }
            }
        }
        
        self.favoriteIconView.isHidden = model.favorites <= 0
        self.favoriteLabel.text = model.favorites <= 0 ? "" : "\(model.favorites)"
        
        self.itemModel = model
    }
}

//MARK: - 点击图片
extension TopicDetailCommentCell : V2CommentAttachmentImageTapDelegate ,V2PhotoBrowserDelegate {
    func V2CommentAttachmentImageSingleTap(_ imageView: V2CommentAttachmentImage) {
        let photoBrowser = V2PhotoBrowser(delegate: self)
        photoBrowser.currentPageIndex = imageView.index
        V2Client.sharedInstance.topNavigationController.present(photoBrowser, animated: true, completion: nil)
    }
    
    //V2PhotoBrowser Delegate
    func numberOfPhotosInPhotoBrowser(_ photoBrowser: V2PhotoBrowser) -> Int {
        return self.itemModel!.images.count
    }
    func photoAtIndexInPhotoBrowser(_ photoBrowser: V2PhotoBrowser, index: Int) -> V2Photo {
        let photo = V2Photo(url: URL(string: self.itemModel!.images[index] as! String)!)
        return photo
    }
    func guideContentModeInPhotoBrowser(_ photoBrowser: V2PhotoBrowser, index: Int) -> UIViewContentMode {
        if let attachment = self.itemModel!.textLayout!.attachments?[index] , let image = attachment.content  as? V2CommentAttachmentImage{
            return image.contentMode
        }
        return .center
    }
    func guideFrameInPhotoBrowser(_ photoBrowser: V2PhotoBrowser, index: Int) -> CGRect {
        if let attachment = self.itemModel!.textLayout!.attachments?[index] , let image = attachment.content  as? V2CommentAttachmentImage{
            return image .convert(image.bounds, to: UIApplication.shared.keyWindow!)
        }
        return CGRect.zero
    }
    func guideImageInPhotoBrowser(_ photoBrowser: V2PhotoBrowser, index: Int) -> UIImage? {
        if let attachment = self.itemModel!.textLayout!.attachments?[index] , let image = attachment.content  as? V2CommentAttachmentImage{
            return image.image
        }
        return nil
    }
}

//MARK: - 长按复制功能
extension TopicDetailCommentCell {
    func longPressHandle(_ longPress:UILongPressGestureRecognizer) -> Void {
        if (longPress.state == .began) {
            self.becomeFirstResponder()
            
            let item = UIMenuItem(title: "复制", action: #selector(TopicDetailCommentCell.copyText))
            
            let menuController = UIMenuController.shared
            menuController.menuItems = [item]
            menuController.arrowDirection = .down
            menuController.setTargetRect(self.frame, in: self.superview!)
            menuController.setMenuVisible(true, animated: true);
        }
        
    }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if (action == #selector(TopicDetailCommentCell.copyText)){
            return true
        }
        return super.canPerformAction(action, withSender: sender);
    }
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    func copyText() -> Void {
        UIPasteboard.general.string = self.itemModel?.textLayout?.text.string
    }
}
//
//  BaseDetailTableViewCell.swift
//  V2ex-Swift
//
//  Created by huangfeng on 1/21/16.
//  Copyright © 2016 Fin. All rights reserved.
//

import UIKit

class BaseDetailTableViewCell: UITableViewCell {
    var titleLabel:UILabel = {
        let label = UILabel()
        label.font = v2Font(16)
        return label
    }()
    
    var detailLabel:UILabel = {
        let label = UILabel()
        label.font = v2Font(13)
        return label
    }()
    
    var detailMarkImageView:UIImageView = {
        let imageview = UIImageView(image: UIImage.imageUsedTemplateMode("ic_keyboard_arrow_right"))
        imageview.contentMode = .center
        return imageview
    }()
    
    var separator:UIImageView = UIImageView()
    
    var detailMarkHidden:Bool {
        get{
            return self.detailMarkImageView.isHidden
        }
        
        set{
            if self.detailMarkImageView.isHidden == newValue{
                return ;
            }
            
            self.detailMarkImageView.isHidden = newValue
            if newValue {
                self.detailMarkImageView.snp.remakeConstraints{ (make) -> Void in
                    make.width.height.equalTo(0)
                    make.centerY.equalTo(self.contentView)
                    make.right.equalTo(self.contentView).offset(-12)
                }
            }
            else{
                self.detailMarkImageView.snp.remakeConstraints{ (make) -> Void in
                    make.width.height.equalTo(20)
                    make.centerY.equalTo(self.contentView)
                    make.right.equalTo(self.contentView).offset(-12)
                }
            }
        }
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.setup();
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup()->Void{
        let selectedBackgroundView = UIView()
        self.selectedBackgroundView = selectedBackgroundView
        
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.detailMarkImageView);
        self.contentView.addSubview(self.detailLabel)
        self.contentView.addSubview(self.separator)
        
        
        self.titleLabel.snp.makeConstraints{ (make) -> Void in
            make.left.equalTo(self.contentView).offset(12)
            make.centerY.equalTo(self.contentView)
        }
        self.detailMarkImageView.snp.remakeConstraints{ (make) -> Void in
            make.height.equalTo(24)
            make.width.equalTo(14)
            make.centerY.equalTo(self.contentView)
            make.right.equalTo(self.contentView).offset(-12)
        }
        self.detailLabel.snp.makeConstraints{ (make) -> Void in
            make.right.equalTo(self.detailMarkImageView.snp.left).offset(-5)
            make.centerY.equalTo(self.contentView)
        }
        self.separator.snp.makeConstraints{ (make) -> Void in
            make.left.right.bottom.equalTo(self.contentView)
            make.height.equalTo(SEPARATOR_HEIGHT)
        }
        
        
        self.thmemChangedHandler = {[weak self] (style) -> Void in
            self?.backgroundColor = V2EXColor.colors.v2_CellWhiteBackgroundColor
            self?.selectedBackgroundView!.backgroundColor = V2EXColor.colors.v2_backgroundColor
            self?.titleLabel.textColor = V2EXColor.colors.v2_TopicListTitleColor
            self?.detailMarkImageView.tintColor = self?.titleLabel.textColor
            self?.detailLabel.textColor = V2EXColor.colors.v2_TopicListUserNameColor
            self?.separator.image = createImageWithColor( V2EXColor.colors.v2_SeparatorColor )
        }
    }
    
}
//
//  V2ActivityViewController.swift
//  V2ex-Swift
//
//  Created by huangfeng on 3/7/16.
//  Copyright © 2016 Fin. All rights reserved.
//

import UIKit

@objc protocol V2ActivityViewDataSource {
    /**
     获取有几个 ，当前不考虑复用，最多仅支持4个，之后会考虑复用并可以返回Int.max多个。
     */
    func V2ActivityView(_ activityView:V2ActivityViewController ,numberOfCellsInSection section: Int) -> Int
    /**
     返回Activity ，主要是标题和图片
     */
    func V2ActivityView(_ activityView:V2ActivityViewController ,ActivityAtIndexPath indexPath:IndexPath) -> V2Activity
    
    /**
     有多少组 ,和UITableView 一样。
     */
    @objc optional func numberOfSectionsInV2ActivityView(_ activityView:V2ActivityViewController) ->Int
    
    @objc optional func V2ActivityView(_ activityView:V2ActivityViewController ,heightForHeaderInSection section: Int) -> CGFloat
    @objc optional func V2ActivityView(_ activityView:V2ActivityViewController ,heightForFooterInSection section: Int) -> CGFloat
    @objc optional func V2ActivityView(_ activityView:V2ActivityViewController ,viewForHeaderInSection section: Int) ->UIView?
    @objc optional func V2ActivityView(_ activityView:V2ActivityViewController ,viewForFooterInSection section: Int) ->UIView?
    
    
    @objc optional func V2ActivityView(_ activityView: V2ActivityViewController, didSelectRowAtIndexPath indexPath: IndexPath)
}

class V2Activity:NSObject {
    var title:String
    var image:UIImage
    init(title aTitle:String , image aImage:UIImage){
        title = aTitle
        image = aImage
    }
}

class V2ActivityButton: UIButton {
    var indexPath:IndexPath?
}


/// 一个和UIActivityViewController 一样的弹出框
class V2ActivityViewController: UIViewController ,UIViewControllerTransitioningDelegate {
    weak var dataSource:V2ActivityViewDataSource?
    
    var section:Int{
        get{
            if let _section = dataSource?.numberOfSectionsInV2ActivityView?(self) {
                return _section
            }
            else {
                return 1
            }
        }
    }
    
    var panel:UIToolbar = UIToolbar()
    
    /**
     当前不考虑复用，每一行最多支持4个cell
     */
    func numberOfCellsInSection(_ section:Int) -> Int{
        if var cells = dataSource?.V2ActivityView(self, numberOfCellsInSection: section) {
            if cells > 4 {
                cells = 4
            }
            return cells
        }
        else{
            return 0
        }
    }
    
    //MARK: - 页面生命周期事件
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0, alpha: 0)
        self.transitioningDelegate = self
        
        self.panel.barStyle = V2EXColor.sharedInstance.style == V2EXColor.V2EXColorStyleDefault ? .default : .black
        self.view.addSubview(self.panel)
        self.panel.snp.makeConstraints{ (make) -> Void in
            make.bottom.equalTo(self.view).offset(-90)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
        }
        self.panel.layer.cornerRadius = 6
        self.panel.layer.masksToBounds = true
        
        self.setupView()
        
        if let lastView = self.panel.subviews.last {
            self.panel.snp.makeConstraints{ (make) -> Void in
                make.bottom.equalTo(lastView)
            }
        }
        
        let cancelPanel = UIToolbar()
        cancelPanel.barStyle = self.panel.barStyle
        cancelPanel.layer.cornerRadius = self.panel.layer.cornerRadius
        cancelPanel.layer.masksToBounds = true
        self.view.addSubview(cancelPanel)
        cancelPanel.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.panel.snp.bottom).offset(10)
            make.left.right.equalTo(self.panel);
            make.height.equalTo(45)
        }
        
        let cancelButton = UIButton()
        cancelButton.setTitle(NSLocalizedString("cancel2"), for: UIControlState())
        cancelButton.titleLabel?.font = v2Font(18)
        cancelButton.setTitleColor(V2EXColor.colors.v2_TopicListTitleColor, for: UIControlState())
        cancelPanel.addSubview(cancelButton)
        cancelButton.snp.makeConstraints{ (make) -> Void in
            make.left.top.right.bottom.equalTo(cancelPanel)
        }
        
        cancelButton.addTarget(self, action: #selector(dismiss as (Void) -> Void), for: .touchUpInside)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss as (Void) -> Void)))
    }
    
    func dismiss(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //#MARK: - 配置视图
    fileprivate func setupView(){
        for i in 0..<section {
            
            //setupHeaderView
            //...
            
            
            //setupSectionView
            let sectionView = self.setupSectionView(i)
            self.panel.addSubview(sectionView)
            sectionView.snp.makeConstraints{ (make) -> Void in
                make.left.right.equalTo(self.panel)
                make.height.equalTo(110)
                if self.panel.subviews.count > 1 {
                    make.top.equalTo(self.panel.subviews[self.panel.subviews.count - 1 - 1].snp.bottom)
                }
                else {
                    make.top.equalTo(self.panel)
                }
            }
            
            //setupFoterView
            self.setupFooterView(i)
        }
    }
    //配置每组的cell
    fileprivate func setupSectionView(_ _section:Int) -> UIView {
        let sectionView = UIView()
        
        let margin = (SCREEN_WIDTH-20 - 60 * 4 )/5.0
        for i in 0..<self.numberOfCellsInSection(_section) {
            let cellView = self.setupCellView(i, currentSection: _section);
            sectionView.addSubview(cellView)
            
            cellView.snp.makeConstraints{ (make) -> Void in
                make.width.equalTo(60)
                make.height.equalTo(80)
                make.centerY.equalTo(sectionView)
                make.left.equalTo(sectionView).offset( CGFloat((i+1)) * margin + CGFloat(i * 60) )
            }
        }
        
        return sectionView
        
    }
    //配置每组的 footerView
    fileprivate func setupFooterView(_ _section:Int) {
        if let view = dataSource?.V2ActivityView?(self, viewForFooterInSection: _section) {
            var height = dataSource?.V2ActivityView?(self, heightForFooterInSection: _section)
            if height == nil {
                height = 40
            }
            
            self.panel.addSubview(view)
            view.snp.makeConstraints{ (make) -> Void in
                make.left.right.equalTo(self.panel)
                make.height.equalTo(height!)
                if self.panel.subviews.count > 1 {
                    make.top.equalTo(self.panel.subviews[self.panel.subviews.count - 1 - 1].snp.bottom)
                }
                else {
                    make.top.equalTo(self.panel)
                }
            }
        }
    }
    //配置每个cell
    fileprivate func setupCellView(_ index:Int , currentSection:Int) -> UIView {
        let cellView = UIView()
        
        let buttonBackgoundView = UIImageView()
        //用颜色生成图片 切成圆角 并拉伸显示
        buttonBackgoundView.image = createImageWithColor(V2EXColor.colors.v2_CellWhiteBackgroundColor, size: CGSize(width: 15, height: 15)).roundedCornerImageWithCornerRadius(5).stretchableImage(withLeftCapWidth: 7, topCapHeight: 7)
        cellView.addSubview(buttonBackgoundView)
        buttonBackgoundView.snp.makeConstraints{ (make) -> Void in
            make.width.height.equalTo(60)
            make.top.left.equalTo(cellView)
        }
        
        let activity = dataSource?.V2ActivityView(self, ActivityAtIndexPath: IndexPath(row: index, section: currentSection))
        
        let button = V2ActivityButton()
        button.setImage(activity?.image.withRenderingMode(.alwaysTemplate), for: UIControlState())
        cellView.addSubview(button)
        button.tintColor = V2EXColor.colors.v2_TopicListUserNameColor
        button.snp.makeConstraints{ (make) -> Void in
            make.top.right.bottom.left.equalTo(buttonBackgoundView)
        }
        
        button.indexPath = IndexPath(row: index, section: currentSection)
        button.addTarget(self, action: #selector(V2ActivityViewController.cellDidSelected(_:)), for: .touchUpInside)
        
        
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.text = activity?.title
        titleLabel.font = v2Font(12)
        titleLabel.textColor = V2EXColor.colors.v2_TopicListTitleColor
        cellView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{ (make) -> Void in
            make.centerX.equalTo(cellView)
            make.left.equalTo(cellView)
            make.right.equalTo(cellView)
            make.top.equalTo(buttonBackgoundView.snp.bottom).offset(5)
        }
        
        
        return cellView
    }
    
    func cellDidSelected(_ sender:V2ActivityButton){
        dataSource?.V2ActivityView?(self, didSelectRowAtIndexPath: sender.indexPath!)
    }
    
    //MARK: - 转场动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return V2ActivityTransionPresent()
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return V2ActivityTransionDismiss()
    }
}

/// 显示转场动画
class V2ActivityTransionPresent:NSObject,UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView
        
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        fromVC?.view.isHidden = true
        let screenshotImage = fromVC?.view.screenshot()
        let tempView = UIImageView(image: screenshotImage)
        tempView.tag = 9988
        container.addSubview(tempView)
        
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        container.addSubview(toVC!.view)
        
        toVC?.view.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 7, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            toVC?.view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
            tempView.transform = CGAffineTransform(scaleX: 0.98, y: 0.98);
        }) { (finished: Bool) -> Void in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

/// 隐藏转场动画
class V2ActivityTransionDismiss:NSObject,UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        container.addSubview(toVC!.view)
        
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        container.addSubview(fromVC!.view)
        
        let tempView = container.viewWithTag(9988)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
            fromVC?.view.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
            tempView!.transform = CGAffineTransform(scaleX: 1, y: 1);
        }, completion: { (finished) -> Void in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            toVC?.view.isHidden = false
        }) 
    }
}
//
//  V2RefreshHeader.swift
//  V2ex-Swift
//
//  Created by huangfeng on 1/27/16.
//  Copyright © 2016 Fin. All rights reserved.
//

import UIKit
import MJRefresh

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
//
//  V2RefreshFooter.swift
//  V2ex-Swift
//
//  Created by huangfeng on 3/1/16.
//  Copyright © 2016 Fin. All rights reserved.
//

import UIKit
import MJRefresh

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
}//
//  V2ProgressHUD.swift
//  V2ex-Swift
//
//  Created by skyline on 16/3/29.
//  Copyright © 2016年 Fin. All rights reserved.
//

import UIKit
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
//
//  NodeModel.swift
//  V2ex-Swift
//
//  Created by huangfeng on 2/2/16.
//  Copyright © 2016 Fin. All rights reserved.
//

import UIKit
import Alamofire
import Ji

class NodeModel: NSObject ,BaseHtmlModelProtocol{
    var nodeId:String?
    var nodeName:String?
    var width:CGFloat = 0
    override init() {
        super.init()
    }
    required init(rootNode: JiNode) {
        self.nodeName = rootNode.content
        if let nodeName = self.nodeName {
            //计算字符串所占的宽度
            //用于之后这个 node 在 cell 中所占的宽度
            let rect = (nodeName as NSString).boundingRect(
                with: CGSize(width: SCREEN_WIDTH,height: 15),
                options: .usesLineFragmentOrigin,
                attributes: [NSFontAttributeName:v2Font(15)], context: nil)
            
            self.width = rect.width;
        }
        
        if var href = rootNode["href"] {
            if let range = href.range(of: "/go/") {
                href.replaceSubrange(range, with: "");
                self.nodeId = href
            }
        }
    }
}
class NodeGroupModel: NSObject ,BaseHtmlModelProtocol{
    var groupName:String?
    var childrenRows:[[Int]] = [[]]
    var children:[NodeModel] = []
    required init(rootNode: JiNode) {
        self.groupName = rootNode.xPath("./td[1]/span").first?.content
        for node in rootNode.xPath("./td[2]/a") {
            self.children.append(NodeModel(rootNode: node))
        }
    }
    
    class func getNodes( _ completionHandler: ((V2ValueResponse<[NodeGroupModel]>) -> Void)? = nil ) {
        Alamofire.request(V2EXURL, headers: MOBILE_CLIENT_HEADERS).responseJiHtml { (response) in
            var groupArray : [NodeGroupModel] = []
            if let jiHtml = response .result.value{
                if let nodes = jiHtml.xPath("//*[@id='Wrapper']/div/div[@class='box'][last()]/div/table/tr") {
                    for rootNode in nodes {
                        let group = NodeGroupModel(rootNode: rootNode)
                        groupArray.append(group)
                    }
                }
                completionHandler?(V2ValueResponse(value: groupArray, success: true))
                return;
            }
            completionHandler?(V2ValueResponse(success: false, message: "获取失败"))
        }
    }
    
}
//
//  UITableView+FINAutomaticHeightCell.swift
//  V2ex-Swift
//
//  Created by huangfeng on 1/12/16.
//  Copyright © 2016 Fin. All rights reserved.
//

import UIKit

extension UITableView {
    
    public func fin_heightForCellWithIdentifier<T: UITableViewCell>(_ identifier: String, configuration: ((_ cell: T) -> Void)?) -> CGFloat {
        if identifier.characters.count <= 0 {
            return 0
        }
        
        let cell = self.fin_templateCellForReuseIdentifier(identifier)
        cell.prepareForReuse()
        
        if configuration != nil {
            configuration!(cell as! T)
        }
        
        //        cell.setNeedsUpdateConstraints();
        //        cell.updateConstraintsIfNeeded();
        //        self.setNeedsLayout();
        //        self.layoutIfNeeded();
        
        var fittingSize = cell.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        if self.separatorStyle != .none {
            fittingSize.height += 1.0 / UIScreen.main.scale
        }
        return fittingSize.height
    }
    
    
    fileprivate func fin_templateCellForReuseIdentifier(_ identifier: String) -> UITableViewCell {
        assert(identifier.characters.count > 0, "Expect a valid identifier - \(identifier)")
        if self.fin_templateCellsByIdentifiers == nil {
            self.fin_templateCellsByIdentifiers = [:]
        }
        var templateCell = self.fin_templateCellsByIdentifiers?[identifier] as? UITableViewCell
        if templateCell == nil {
            templateCell = self.dequeueReusableCell(withIdentifier: identifier)
            assert(templateCell != nil, "Cell must be registered to table view for identifier - \(identifier)")
            templateCell?.contentView.translatesAutoresizingMaskIntoConstraints = false
            self.fin_templateCellsByIdentifiers?[identifier] = templateCell
        }
        
        return templateCell!
    }
    
    public func fin_heightForCellWithIdentifier<T: UITableViewCell>(_ identifier: T.Type, indexPath: IndexPath, configuration: ((_ cell: T) -> Void)?) -> CGFloat {
        let identifierStr = "\(identifier)";
        if identifierStr.characters.count == 0 {
            return 0
        }
        
        //         Hit cache
        if self.fin_hasCachedHeightAtIndexPath(indexPath) {
            let height: CGFloat = self.fin_indexPathHeightCache![indexPath.section][indexPath.row]
            //            NSLog("hit cache by indexPath:[\(indexPath.section),\(indexPath.row)] -> \(height)");
            return height
        }
        
        let height = self.fin_heightForCellWithIdentifier(identifierStr, configuration: configuration)
        self.fin_indexPathHeightCache![indexPath.section][indexPath.row] = height
        //        NSLog("cached by indexPath:[\(indexPath.section),\(indexPath.row)] --> \(height)")
        
        return height
    }
    
    fileprivate struct AssociatedKey {
        static var CellsIdentifier = "me.fin.cellsIdentifier"
        static var HeightsCacheIdentifier = "me.fin.heightsCacheIdentifier"
        static var finHeightCacheAbsendValue = CGFloat(-1);
    }
    
    fileprivate func fin_hasCachedHeightAtIndexPath(_ indexPath:IndexPath) -> Bool {
        self.fin_buildHeightCachesAtIndexPathsIfNeeded([indexPath]);
        let height = self.fin_indexPathHeightCache![indexPath.section][indexPath.row];
        return height >= 0;
    }
    
    fileprivate func fin_buildHeightCachesAtIndexPathsIfNeeded(_ indexPaths:Array<IndexPath>) -> Void {
        if indexPaths.count <= 0 {
            return ;
        }
        
        if self.fin_indexPathHeightCache == nil {
            self.fin_indexPathHeightCache = [];
        }
        
        for indexPath in indexPaths {
            let cacheSectionCount = self.fin_indexPathHeightCache!.count;
            if  indexPath.section >= cacheSectionCount {
                for i in cacheSectionCount...indexPath.section {
                    if i >= self.fin_indexPathHeightCache!.count{
                        self.fin_indexPathHeightCache!.append([])
                    }
                }
            }
            
            let cacheCount = self.fin_indexPathHeightCache![indexPath.section].count;
            if indexPath.row >= cacheCount {
                for i in cacheCount...indexPath.row {
                    if i >= self.fin_indexPathHeightCache![indexPath.section].count {
                        self.fin_indexPathHeightCache![indexPath.section].append(AssociatedKey.finHeightCacheAbsendValue);
                    }
                }
            }
        }
        
    }
    
    fileprivate var fin_templateCellsByIdentifiers: [String : AnyObject]? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.CellsIdentifier) as? [String : AnyObject]
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.CellsIdentifier, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    fileprivate var fin_indexPathHeightCache: [ [CGFloat] ]? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.HeightsCacheIdentifier) as? [[CGFloat]]
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.HeightsCacheIdentifier, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func fin_reloadData(){
        self.fin_indexPathHeightCache = [[]];
        self.reloadData();
    }
    
}
//
//  V2ex+Define.swift
//  V2ex-Swift
//
//  Created by huangfeng on 1/11/16.
//  Copyright © 2016 Fin. All rights reserved.
//

import UIKit


let SCREEN_WIDTH = UIScreen.main.bounds.size.width;
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height;




let SEPARATOR_HEIGHT = 1.0 / UIScreen.main.scale


func NSLocalizedString( _ key:String ) -> String {
    return NSLocalizedString(key, comment: "")
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

func v2ScaleFont(_ fontSize: CGFloat) -> UIFont{
    return v2Font(fontSize * CGFloat(V2Style.sharedInstance.fontScale))
}

func createImageWithColor(_ color:UIColor) -> UIImage{
    return createImageWithColor(color, size: CGSize(width: 1, height: 1))
}
func createImageWithColor(_ color:UIColor,size:CGSize) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    UIGraphicsBeginImageContext(rect.size);
    let context = UIGraphicsGetCurrentContext();
    context?.setFillColor(color.cgColor);
    context?.fill(rect);
    
    let theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage!;
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

//
//  AnalyzeURLHelper.swift
//  V2ex-Swift
//
//  Created by huangfeng on 2/18/16.
//  Copyright © 2016 Fin. All rights reserved.
//

import UIKit

class AnalyzeURLHelper {
    /**
     分析URL 进行相应的操作
     
     - parameter url: 各种URL 例如https://baidu.com 、/member/finab 、/t/100000
     */
    @discardableResult
    class func Analyze(_ url:String) -> Bool {
        let result = AnalyzURLResultType(url: url)
        switch result {
            
        case .url(let url):
            url.run()
            
        case .member(let member):
            member.run()
            
        case .topic(let topic):
            topic.run()
            
        case .undefined :
            return false
        }
        
        return true
    }
}

enum AnalyzURLResultType {
    /// 普通URL链接
    case url(UrlActionModel)
    /// 用户
    case member(MemberActionModel)
    /// 帖子链接
    case topic(TopicActionModel)
    /// 未定义
    case undefined
    
    private enum `Type` : Int {
        case url, member, topic , undefined
    }
    
    private static let patterns = [
        "^(http|ftp|https):\\/\\/[\\w\\-_]+(\\.[\\w\\-_]+)+([\\w\\-\\.,@?^=%&amp;:/~\\+#]*[\\w\\-\\@?^=%&amp;/~\\+#])?",
        "^(http:\\/\\/|https:\\/\\/)?(www\\.)?(v2ex.com)?/member/[a-zA-Z0-9_]+$",
        "^(http:\\/\\/|https:\\/\\/)?(www\\.)?(v2ex.com)?/t/[0-9]+",
        ]
    
    init(url:String) {
        var resultType:AnalyzURLResultType = .undefined
        
        var type = Type.undefined
        for pattern in AnalyzURLResultType.patterns {
            let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            regex.enumerateMatches(in: url, options: .withoutAnchoringBounds, range: NSMakeRange(0, url.Lenght), using: { (result, _, _) -> Void in
                if let result = result {
                    let range = result.range
                    if range.location == NSNotFound || range.length <= 0 {
                        return ;
                    }
                    
                    type = Type(rawValue: AnalyzURLResultType.patterns.index(of: pattern)!)!
                    
                    switch type {
                    case .url:
                        if let action = UrlActionModel(url: url) {
                            resultType = .url(action)
                        }
                        
                    case .member :
                        if let action = MemberActionModel(url: url) {
                            resultType = .member(action)
                        }
                        
                    case .topic:
                        if let action = TopicActionModel(url: url) {
                            resultType = .topic(action)
                        }
                        
                    default:break
                    }
                }
            })
        }
        
        self = resultType
    }
}

protocol AnalyzeURLActionProtocol {
    init?(url:String)
    func run()
}

struct UrlActionModel: AnalyzeURLActionProtocol{
    var url:String
    init?(url:String) {
        self.url = url;
    }
    func run() {
//        let controller = V2WebViewViewController(url: url)
//        V2Client.sharedInstance.topNavigationController.pushViewController(controller, animated: true)
    }
}

struct MemberActionModel: AnalyzeURLActionProtocol {
    var username:String
    init?(url:String) {
        if  let range = url.range(of: "/member/") {
            self.username = url.substring(from: range.upperBound)
        }
        else{
            return nil
        }
    }
    func run() {
//        let memberViewController = MemberViewController()
//        memberViewController.username = username
//        V2Client.sharedInstance.topNavigationController.pushViewController(memberViewController, animated: true)
    }
}

struct TopicActionModel: AnalyzeURLActionProtocol {
    var topicID:String
    init?(url:String) {
        if  let range = url.range(of: "/t/") {
            var topicID = url.substring(from: range.upperBound)
            
            if let range = topicID.range(of: "?"){
                topicID = topicID.substring(to: range.lowerBound)
            }
            
            if let range = topicID.range(of: "#"){
                topicID = topicID.substring(to: range.lowerBound)
            }
            self.topicID = topicID
        }
        else{
            return nil;
        }
    }
    func run() {
        let controller = TopicDetailViewController()
        controller.topicId = topicID
//        V2Client.sharedInstance.topNavigationController.pushViewController(controller, animated: true)
    }
}


extension AnalyzeURLHelper {
    /**
     测试
     */
    class func test() -> Void {
        var urls  = [
            "http://v2ex.com/member/finab",
            "https://v2ex.com/member/finab",
            "http://www.v2ex.com/member/finab",
            "https://www.v2ex.com/member/finab",
            "v2ex.com/member/finab",
            "www.v2ex.com/member/finab",
            "/member/finab",
            "/MEMBER/finab"
        ]
        urls.forEach { (url) in
            let result = AnalyzURLResultType(url: url)
            if case AnalyzURLResultType.member(let member) = result {
                print(member.username)
            }
            else{
                assert(false, "不能解析member : " + url )
            }
            
        }
        
        urls = [
            "member/finab",
            "www.baidu.com/member/finab",
            "com/member/finab",
            "www.baidu.com",
            "http://www.baidu.com"
        ]
        urls.forEach { (url) in
            let result = AnalyzURLResultType(url: url)
            if case AnalyzURLResultType.member(_) = result {
                assert(true, "解析了不是member的URL : " + url )
            }
        }
    }
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
