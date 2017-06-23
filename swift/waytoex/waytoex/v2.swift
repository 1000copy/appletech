
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
        Alamofire.request(url, parameters: params, headers: MOBILE_CLIENT_HEADERS).response(responseSerializer: ResponseSerializer.JI()) {
            var resultArray:[TopicListModel] = []
            if  let jiHtml = $0.result.value ,
                let aRootNode = jiHtml.xPath("//body/div[@id='Wrapper']/div[@class='content']/div[@class='box']/div[@class='cell item']")
            {
                
                for aNode in aRootNode {
                        resultArray += [ TopicListModel(rootNode:aNode)];
                }
            }
            completionHandler(resultArray);
        }
    }
}

class ResponseSerializer {
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
    
    static func JI() -> DataResponseSerializer<Ji> {
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
}

