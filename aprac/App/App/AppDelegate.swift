import aprac
@UIApplicationMain
class App: AppBase {
    override func main() -> Any{
        let p = P()
        let p2 = P2()
        let p3 = P3()
        return Nav([p,p2,p3])
    }
}
class P : Page{
    override func loaded() {
        view.backgroundColor = .green
        let bgImage = UIImageView()
        bgImage.frame = CGRect(x: 0,y: 0,width: 100,height: 100)
        bgImage.image = Image.block(UIColor.red)
        self.view.addSubview(bgImage)
    }
}
class P2 : Page{
    override func loaded() {
        view.backgroundColor = .blue
        let bgImage = UIImageView()
        bgImage.frame = CGRect(x: 0,y: 0,width: 100,height: 100)
        bgImage.image = Image.block(UIColor.red)
        self.view.addSubview(bgImage)
    }
}
class P3 : Page{
    override func loaded() {
        view.backgroundColor = .red
        let bgImage = UIImageView()
        bgImage.frame = CGRect(x: 0,y: 0,width: 100,height: 100)
        bgImage.image = Image.block(UIColor.red)
        self.view.addSubview(bgImage)
    }
}
//class N : Nav{
//    override func loaded() {
//    }
//}
