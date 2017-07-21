每次加载WebView内容，如果图片可以缓存的话，速度就会非常快。默认情况下，WebView自己来加载图片，缓存的策略也是自己定的。如想要自己缓存的话，那么可以使用URLSessionDataDelegate来截获HTTP访问，如果访问的是图片的话，就自己去发起请求，缓存，如果缓存了的话，就提取缓存，自己构建一个HTTP响应对象返回。

如下案例，使用了Kingfisher库做实际的图片缓存，从而隔离开和文件操作相关的细节。代码来自: https://github.com/Finb/V2ex-Swift/blob/master/Common/WebViewImageProtocol.swift 。可以使用，但是代码有些破碎，晚点有时间才调整。



    import UIKit
    import Kingfisher
    class Page: UIViewController,UIGestureRecognizerDelegate{
        var c : UIWebView!
        var tapGesture : UITapGestureRecognizer!
        override func viewDidLoad() {
            super.viewDidLoad()
            c = UIWebView()
            c.frame = super.view.frame
            view.addSubview(c)
            c.frame.origin.y += 100
            c.frame.size.height = 100
            c.frame.size.width = 100
            let button = UIButton()
            button.setTitle("reload", for: .normal)
            button.addTarget(self, action: #selector(tap), for: .touchDown)
            button.frame = CGRect(x: 0, y: 70, width: 100, height: 20)
            view.addSubview(button)
        }
        func tap(){
            loadurl()
        }
        func loadurl(){
            let url = URL(string:"https://httpbin.org/image/png")//must be a https url ,otherwise iOS will fobidden it
            let ro = URLRequest(url:url!)
            c.loadRequest(ro)
        }
    }
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        var window: UIWindow?
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            URLProtocol.registerClass(WebViewImageProtocol.self)
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window!.rootViewController = Page()
            self.window?.makeKeyAndVisible()
            return true
        }
    }
    fileprivate let WebviewImageProtocolHandledKey = "WebviewImageProtocolHandledKey"
    
    class WebViewImageProtocol: URLProtocol ,URLSessionDataDelegate {
        var session: URLSession?
        var dataTask: URLSessionDataTask?
        var imageData: Data?
        
        override class func canInit(with request: URLRequest) -> Bool{
            let b = request.url?.absoluteURL.absoluteString.contains("png")
            if b! {
                if let tag = self.property(forKey: WebviewImageProtocolHandledKey, in: request) as? Bool , tag == true {
                    return false
                }
                return true
            }
            return false
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest{
            return request
        }
        override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
            return super.requestIsCacheEquivalent(a, to: b)
        }
        override func startLoading() {
            let resource = ImageResource(downloadURL: self.request.url!)
            let data = try? Data(contentsOf:URL(fileURLWithPath: KingfisherManager.shared.cache.cachePath(forKey: resource.cacheKey)))
            if let data = data {
                //在磁盘上找到Kingfisher的缓存，则直接使用缓存
                print("hitted")
                var mimeType = data.contentTypeForImageData()
                mimeType.append(";charset=UTF-8")
                let header = ["Content-Type": mimeType
                    ,"Content-Length": String(data.count)]
                let response = HTTPURLResponse(url: self.request.url!, statusCode: 200, httpVersion: "1.1", headerFields: header)!
                
                self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
                self.client?.urlProtocol(self, didLoad: data)
                self.client?.urlProtocolDidFinishLoading(self)
            }
            else{
                //没找到图片则下载
                print("caching")
                guard let newRequest = (self.request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else {return}
                WebViewImageProtocol.setProperty(true, forKey: WebviewImageProtocolHandledKey, in: newRequest)
                
                self.session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
                self.dataTask = self.session?.dataTask(with:newRequest as URLRequest)
                self.dataTask?.resume()
            }
        }
        override func stopLoading() {
            self.dataTask?.cancel()
            self.dataTask = nil
            self.imageData = nil
        }
        func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
            completionHandler(.allow)
        }
        func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
            self.client?.urlProtocol(self, didLoad: data)
            if self.imageData == nil {
                self.imageData = data
            }
            else{
                self.imageData!.append(data)
            }
        }
        func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
            if let error = error {
                self.client?.urlProtocol(self, didFailWithError: error)
            }
            else{
                self.client?.urlProtocolDidFinishLoading(self)
                
                let resource = ImageResource(downloadURL: self.request.url!)
                guard let imageData = self.imageData else { return }
                //保存图片到Kingfisher
                guard  let image = DefaultCacheSerializer.default.image(with: imageData, options: nil) else { return }
                KingfisherManager.shared.cache.store(image, original: imageData, forKey: resource.cacheKey,  toDisk: true){
                    print("cached")
                }
            }
        }
    }
    fileprivate extension Data {
        func contentTypeForImageData() -> String {
            var c:UInt8 = 0
            self.copyBytes(to: &c, count: MemoryLayout<UInt8>.size * 1)
            switch c {
            case 0xFF:
                return "image/jpeg";
            case 0x89:
                return "image/png";
            case 0x47:
                return "image/gif";
            default:
                return ""
            }
        }
    }
运行后点击按钮reload两次输出为：
    caching
    cached
    hitted