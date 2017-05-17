import aprac
@UIApplicationMain
class App: AppBase {
    override func main() -> Page{
        return P()
    }
}
class P : Page{
    override func viewDidLoad() {
        view.backgroundColor = .green
    }
}
