import Kingfisher
import MJRefresh
import UIKit
import Alamofire
import Ji

let  V2EXURL = "https://www.v2ex.com/"
let MOBILE_CLIENT_HEADERS = ["user-agent":
    "Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.3 (KHTML, like Gecko) Version/8.0 Mobile/12A4345d Safari/600.1.4"]

class v2{
    
    class func getTopicList(
        _ tab: String? = nil ,
        page:Int = 0 ,
        //        completionHandler: @escaping (V2ValueResponse<[TopicListModel]>) -> Void
        completionHandler: @escaping ([TopicListModel]) -> Void
        )->Void{
        
        var params:[String:String] = [:]
        if let tab = tab {
            params["tab"]=tab
        }
        else {
            params["tab"] = "all"
        }
        
        var url = V2EXURL
        if params["tab"] == "all" && page > 0 {
            params.removeAll()
            params["p"] = "\(page)"
            url = V2EXURL + "recent"
        }
        
        Alamofire.request(url, parameters: params, headers: MOBILE_CLIENT_HEADERS).responseJiHtml { (response) -> Void in
            var resultArray:[TopicListModel] = []
            if  let jiHtml = response.result.value{
                //                print(jiHtml)
                if let aRootNode = jiHtml.xPath("//body/div[@id='Wrapper']/div[@class='content']/div[@class='box']/div[@class='cell item']"){
                    //                if let aRootNode = jiHtml.xPath("div[@class='cell']"){
                    for aNode in aRootNode {
                        let topic = TopicListModel(rootNode:aNode)
                        resultArray.append(topic);
                    }
                }
            }
            //            let t = V2ValueResponse<[TopicListModel]>(value:resultArray, success: response.result.isSuccess)
            completionHandler(resultArray);
        }
    }
}
