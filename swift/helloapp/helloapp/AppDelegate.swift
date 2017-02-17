//
//  AppDelegate.swift
//  helloapp
//
//  Created by quota on 2/18/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit


class ViewController1: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green
        let button = UIButton()
        button.setTitle("transit", for: UIControlState())
        button.frame = CGRect(x: 20, y: 20, width: 100,height: 20)
        button.addTarget(self, action: #selector(ViewController1.click(_:)), for: .touchDown)
        view.addSubview(button)
    }
    func click(_ sender:UIButton!){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let window = appDelegate.window {
//            let v2 = ViewController2()
            
            if let r = window.rootViewController{
                r.transition(
                    from: appDelegate.v1!
                    ,to:appDelegate.v2!,duration:0.8,options: .transitionFlipFromLeft,animations:nil){_ in }
            }
        }
    }
    
}


class ViewController2: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue
    }
    override func viewWillAppear(_ animated: Bool) {
        print(animated)
    }

}

class ViewController3: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var v1 : ViewController1?
    var v2 : ViewController2?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.rootViewController = ViewController3()
        v1 = ViewController1()
        v2 = ViewController2()
        v1!.view.frame = self.window!.frame
        self.window!.rootViewController?.addChildViewController(v1!)
        self.window!.rootViewController?.view.addSubview(v1!.view)
        self.window!.rootViewController?.addChildViewController(v2!)
        
        self.window?.makeKeyAndVisible()
        return true
    }
}

