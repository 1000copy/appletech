import aprac
@UIApplicationMain
class App: AppBase {
    var nav : N?
//    override func main() -> Any{
//        nav = N()
//        return nav!
//    }
    override func main() -> Any{
        return  Pages()
    }
}
class  Pages : MultiPage{
    override func Pages() ->[Page]{
        return [P(),P2()]
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
        button.parent = self
        button.touch = "buttonAction:"
        button.rect = [120,100,100,50]
        button.title = "Dive Into 2"
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
        let button   = Button(type: .system)
        button.parent = self
        button.touch = "buttonAction:"
        button.rect = [120,100,100,50]
        button.title = "Dive Into 3"
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
        let button   = Button(type: .system)
        button.parent = self
        button.touch = "buttonAction:"
        button.rect = [120,100,100,50]
        button.title = "Pop"
        view.addSubview(button)
    }
    func buttonAction(_ sender:UIButton!){
        let app = App.gate as! App
        app.nav?.pop()
    }
}
