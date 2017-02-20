

import UIKit
import AVFoundation

let screenwidth = 300
let gap = 3
let buttonwidth = 40
let buttonheight = 40
let ystart = 70
var currentx = 0
var currenty = ystart
let nr = 10
class Alphabet:UIButton{
    
}
class Page1: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        def = [Abc]()
        LongYuan()
        ShortYuan()
        ShuangYuan()
        QingFu()
        ZuoFu()
        Other()
    }
    func normalTap(_ sender:UIButton!){
        print("normalTap clicked")
        
    }
    func longTap(sender : UIGestureRecognizer){
        
        if sender.state == .began{
            print("longTap clicked")
            if let button = sender.view as? UIButton {
                print(button.titleLabel!.text!)
                    let mainView = Page2(nibName: nil, bundle: nil)
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.nav1!.pushViewController(mainView,animated: true)

            }
                  }
    }
    func longTap1(sender : UIGestureRecognizer){
        if sender.state == .ended{
            print("longTap clicked")
            let mainView = Page2(nibName: nil, bundle: nil)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.nav1!.pushViewController(mainView,animated: true)
        }
    }

    var def : [Abc]?
    var player: AVAudioPlayer?
    func join(abc:[Abc]){
        for a in abc{
            self.def!.append(a)
        }
    }
    func LongYuan (){
        
        var abc = [Abc]()
        // 长元音 [iː] [ɜː] [ɔː] [uː] [ɑː]
        abc.append(Abc(alpha: "ɑː",mp3: "mp3/Long/a-sound2"))
        abc.append(Abc(alpha: "uː",mp3: "mp3/Long/u-sound2"))
        abc.append(Abc(alpha: "ɔː",mp3: "mp3/Long/o-sound2"))
        abc.append(Abc(alpha: "ɜː",mp3: "mp3/Long/er-sound"))
        abc.append(Abc(alpha: "iː",mp3: "mp3/Long/i-sound2"))
        var i = 0
        for a in abc{
            let button1   = UIButton(type: UIButtonType.system) as UIButton
            button1.titleLabel!.font =   UIFont(name: "HelveticaNeue", size: 26)
            button1.titleLabel!.textColor = UIColor.white
            
            button1.frame = CGRect(x: currentx, y: currenty, width: buttonwidth, height: buttonheight)
            currentx += buttonwidth + gap
            if currentx + buttonwidth >= screenwidth {
                currentx = 0
                if i+1 < abc.count{
                    currenty += buttonheight + gap
                }
            }
            button1.backgroundColor = UIColor.green
            button1.setTitle(a.alpha, for: UIControlState())
            button1.addTarget(self, action: #selector(Page1.buttonAction1(_:)), for: UIControlEvents.touchUpInside)
            view.addSubview(button1)
            let longGesture = UILongPressGestureRecognizer(target: self,  action:#selector(Page1.longTap(sender:)))
            button1.addGestureRecognizer(longGesture)
            i += 1
        }
        self.join(abc:abc)
    }
    func ShortYuan (){
        currentx = 0
        currenty += buttonheight + gap + nr
        var abc = [Abc]()
        // 短元音	[ɪ] [e] [ʌ] [ə] [ɒ] [ʊ] [æ]
        abc.append(Abc(alpha: "ɪ",mp3: "mp3/Duan/i-sound"))
        abc.append(Abc(alpha: "e",mp3: "mp3/Duan/e-sound"))
        abc.append(Abc(alpha: "ʌ",mp3: "mp3/Duan/^-sound"))
        abc.append(Abc(alpha: "ə",mp3: "mp3/Duan/e^-sound"))
        abc.append(Abc(alpha: "ɒ",mp3: "mp3/Duan/o-sound"))
        abc.append(Abc(alpha: "ʊ",mp3: "mp3/Duan/u-sound"))
        abc.append(Abc(alpha: "æ",mp3: "mp3/Duan/an-sound"))
        var i = 0
        for a in abc{
            let button1   = UIButton(type: UIButtonType.system) as UIButton
            button1.titleLabel!.font =   UIFont(name: "HelveticaNeue", size: 26)
            button1.frame = CGRect(x: currentx, y: currenty, width: buttonwidth, height: buttonheight)
            currentx += buttonwidth + gap
            if currentx + buttonwidth >= screenwidth {
                currentx = 0
                if i+1 < abc.count{
                    currenty += buttonheight + gap
                }

                
            }
            button1.backgroundColor = UIColor.green
            button1.setTitle(a.alpha, for: UIControlState())
            button1.addTarget(self, action: #selector(Page1.buttonAction1(_:)), for: UIControlEvents.touchUpInside)
            view.addSubview(button1)
            i += 1
        }
        self.join(abc:abc)
    }
    func ShuangYuan (){
        currentx = 0
        currenty += buttonheight + gap + nr
        var abc = [Abc]()
        // 双元音	[eɪ] [aɪ] [ɔɪ] [aʊ] [əʊ] [ɪə] [eə] [ʊə]
        abc.append(Abc(alpha: "eɪ",mp3: "mp3/Shuang/ei"))
        abc.append(Abc(alpha: "aɪ",mp3: "mp3/Shuang/ai"))
        abc.append(Abc(alpha: "ɔɪ",mp3: "mp3/Shuang/oi"))
        abc.append(Abc(alpha: "aʊ",mp3: "mp3/Shuang/ao"))
        abc.append(Abc(alpha: "əʊ",mp3: "mp3/Shuang/eu"))
        abc.append(Abc(alpha: "ɪə",mp3: "mp3/Shuang/ir"))
        abc.append(Abc(alpha: "eə",mp3: "mp3/Shuang/er"))
        abc.append(Abc(alpha: "ʊə",mp3: "mp3/Shuang/uer"))
        var i = 0
        for a in abc{
            let button1   = UIButton(type: UIButtonType.system) as UIButton
            button1.titleLabel!.font =   UIFont(name: "HelveticaNeue", size: 26)
            button1.frame = CGRect(x: currentx, y: currenty, width: buttonwidth, height: buttonheight)
            currentx += buttonwidth + gap
            if currentx + buttonwidth >= screenwidth {
                currentx = 0
                currenty += buttonheight + gap
            }
            button1.backgroundColor = UIColor.green
            button1.setTitle(a.alpha, for: UIControlState())
            button1.addTarget(self, action: #selector(Page1.buttonAction1(_:)), for: UIControlEvents.touchUpInside)
            view.addSubview(button1)
            i += 1
        }
        self.join(abc:abc)
    }
    func QingFu (){
        currentx = 0
        currenty += buttonheight + gap + nr
        var abc = [Abc]()
        // 清辅音	[p] [t] [k] [f] [θ] [s] [ts][tr] [∫] [t∫]
        abc.append(Abc(alpha: "p",mp3: "mp3/Qingfu/p"))
        abc.append(Abc(alpha: "t",mp3: "mp3/Qingfu/t"))
        abc.append(Abc(alpha: "k",mp3: "mp3/Qingfu/k"))
        abc.append(Abc(alpha: "f",mp3: "mp3/Qingfu/f"))
        abc.append(Abc(alpha: "θ",mp3: "mp3/Qingfu/si"))
        abc.append(Abc(alpha: "ts",mp3: "mp3/Qingfu/ts"))
        abc.append(Abc(alpha: "tr",mp3: "mp3/Qingfu/tr"))
        abc.append(Abc(alpha: "∫",mp3: "mp3/Qingfu/ss"))
        abc.append(Abc(alpha: "t∫",mp3: "mp3/Qingfu/tss"))
        var i = 0
        for a in abc{
            let button1   = UIButton(type: UIButtonType.system) as UIButton
            button1.titleLabel!.font =   UIFont(name: "HelveticaNeue", size: 26)
            button1.frame = CGRect(x: currentx, y: currenty, width: buttonwidth, height: buttonheight)
            currentx += buttonwidth + gap
            if currentx + buttonwidth >= screenwidth {
                currentx = 0
                currenty += buttonheight + gap
            }
            button1.backgroundColor = UIColor.green
            button1.setTitle(a.alpha, for: UIControlState())
            button1.addTarget(self, action: #selector(Page1.buttonAction1(_:)), for: UIControlEvents.touchUpInside)
            view.addSubview(button1)
            i += 1
        }
        self.join(abc:abc)
    }
    func ZuoFu (){
        currentx = 0
        currenty += buttonheight + gap + nr
        var abc = [Abc]()
        // 浊辅音	[b] [d] [g] [v] [ð] [z] [dz] [dr] [ʒ] [dʒ]
        abc.append(Abc(alpha: "b",mp3: "mp3/Zuofu/b"))
        abc.append(Abc(alpha: "d",mp3: "mp3/Zuofu/d"))
        abc.append(Abc(alpha: "g",mp3: "mp3/Zuofu/g"))
        abc.append(Abc(alpha: "v",mp3: "mp3/Zuofu/v"))
        abc.append(Abc(alpha: "ð",mp3: "mp3/Zuofu/qq"))
        abc.append(Abc(alpha: "z",mp3: "mp3/Zuofu/z"))
        abc.append(Abc(alpha: "dz",mp3: "mp3/Zuofu/dz"))
        abc.append(Abc(alpha: "dr",mp3: "mp3/Zuofu/dr"))
        abc.append(Abc(alpha: "ʒ",mp3: "mp3/Zuofu/n3"))
        abc.append(Abc(alpha: "dʒ",mp3: "mp3/Zuofu/d3"))
        var i = 0
        for a in abc{
            let button1   = UIButton(type: UIButtonType.system) as UIButton
            button1.titleLabel!.font =   UIFont(name: "HelveticaNeue", size: 26)
            button1.frame = CGRect(x: currentx, y: currenty, width: buttonwidth, height: buttonheight)
            currentx += buttonwidth + gap
            if currentx + buttonwidth >= screenwidth {
                currentx = 0
                currenty += buttonheight + gap
            }
            button1.backgroundColor = UIColor.green
            button1.setTitle(a.alpha, for: UIControlState())
            button1.addTarget(self, action: #selector(Page1.buttonAction1(_:)), for: UIControlEvents.touchUpInside)
            view.addSubview(button1)
            i += 1
        }
        self.join(abc:abc)
    }
    func Other (){
        currentx = 0
        currenty += buttonheight + gap + nr
        var abc = [Abc]()
        // 其他 	[m][n][ŋ][h][l][r][j][w]
        abc.append(Abc(alpha: "m",mp3: "mp3/Other/m"))
        abc.append(Abc(alpha: "n",mp3: "mp3/Other/n"))
        abc.append(Abc(alpha: "ŋ",mp3: "mp3/Other/ng"))
        abc.append(Abc(alpha: "h",mp3: "mp3/Other/h"))
        abc.append(Abc(alpha: "l",mp3: "mp3/Other/l"))
        abc.append(Abc(alpha: "r",mp3: "mp3/Other/r"))
        abc.append(Abc(alpha: "j",mp3: "mp3/Other/j"))
        abc.append(Abc(alpha: "w",mp3: "mp3/Other/w"))
        var i = 0
        for a in abc{
            let button1   = UIButton(type: UIButtonType.system) as UIButton
            button1.titleLabel!.font =   UIFont(name: "HelveticaNeue", size: 26)
            button1.frame = CGRect(x: currentx, y: currenty, width: buttonwidth, height: buttonheight)
            currentx += buttonwidth + gap
            if currentx + buttonwidth >= screenwidth {
                currentx = 0
                currenty += buttonheight + gap
            }
            button1.backgroundColor = UIColor.green
            button1.setTitle(a.alpha, for: UIControlState())
            button1.addTarget(self, action: #selector(Page1.buttonAction1(_:)), for: UIControlEvents.touchUpInside)
            view.addSubview(button1)
            i += 1
        }
        self.join(abc:abc)
    }
 
    func playSound(file:String) {
        let url = Bundle.main.url(forResource: file, withExtension: "mp3")!
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func buttonAction1(_ sender:UIButton!){
        print("button1 clicked")
        var a = sender.titleLabel!.text!
        print(a)
        for b in def!{
            if b.alpha == a{
                playSound(file:b.mp3)
            }
        }
    }
    
}

class Page2: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button   = UIButton(type: UIButtonType.system) as UIButton
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 50)
        button.backgroundColor = UIColor.green
        button.setTitle("Test Button", for: UIControlState())
        button.addTarget(self, action: #selector(Page2.buttonAction(_:)), for: UIControlEvents.touchUpInside)
        view.addSubview(button)
    }
    func buttonAction(_ sender:UIButton!){
        print("button clicked")
//        dismiss(animated: true, completion: nil)
        goBack()
    }
    
    func goBack(){
//        dismiss(animated: true, completion: nil)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.nav1!.popViewController(animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

class Abc{
    var alpha : String
    var mp3: String
    init(alpha:String,mp3:String){
        self.alpha = alpha
        self.mp3 = mp3
    }
}


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var nav1 : UINavigationController?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        nav1 = UINavigationController()
        let page1 = Page1(nibName: nil, bundle: nil)
        nav1!.viewControllers = [page1]
        nav1!.title = "Page1"
        self.window!.rootViewController = nav1
        //self.window!.rootViewController = page1
        self.window?.makeKeyAndVisible()
        return true
    }
}
