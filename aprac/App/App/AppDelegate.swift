import aprac
@UIApplicationMain
class App: AppBase {
    var nav : N?
    override func main() -> Any{
        nav = N()
        return nav!
    }
}
class N : Nav{
    override var homePage : Page{
    get{
        return P()
    }
    }
}
class P : Page{
    override func loaded() {
        self.title = "Level 1"
        let button   = Button(type: .system)
//        button.frame = CGRect(x: 120, y: 100, width: 100, height: 50)
         button.frame = Frame(120,100,100,50)
        button.setTitle("Dive Into 2",for: .normal)
//        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
//        button.addTarget(self, action: Selector("buttonAction:"), for: .touchUpInside)
        button.parent = self
        button.touch = "buttonAction:"
        
        view.addSubview(button)
    }
    func buttonAction(_ sender:UIButton!){
        let app = App.gate as! App
        app.nav?.push(P2())
    }
}
class P2 : Page{
    override func loaded() {
        self.title = "Level 2"
        let button   = UIButton(type: .system)
        button.frame = CGRect(x: 120, y: 100, width: 100, height: 50)
        button.setTitle("Dive Into 3",for: .normal)
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        view.addSubview(button)
    }
    func buttonAction(_ sender:UIButton!){
        let app = App.gate as! App
        app.nav?.push(P3())
    }
}
class P3 : Page{
    override func loaded() {
        self.title = "Level 3"
        let button   = UIButton(type: .system)
        button.frame = CGRect(x: 120, y: 100, width: 100, height: 50)
        button.setTitle("Pop",for: .normal)
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        view.addSubview(button)
    }
    func buttonAction(_ sender:UIButton!){
        let app = App.gate as! App
        app.nav?.pop()
    }
}
