// 1 . 初识swift，xcode
// 知识点
// 添加一个按钮，点击按钮后显示一个警告控制器
// UI构造，事件连接(别忘了事件方法名后面需要加入“：”），闭包(2种编写方法，内置，外置）。视图控制器，viewDidLoad。
// 改造为全代码方式
// 2. todo app
// NavigationController,TableViewController , Cell ,NavigationBarItem,Event ,
//  ViewController.swift
//  doudou
//
//  Created by quota on 1/17/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let button = UIButton(frame: CGRect(x: 10,y: 50,width: 200,height: 50))
        let button = UIButton()
        button.frame = CGRectMake(10,50,200,50)
        self.view.addSubview(button)
        button.backgroundColor = UIColor.blueColor()
        button.setTitle("who am i ? ", forState: .Normal)
        button.addTarget(self, action: "clickme:", forControlEvents: .TouchDown)
    }
    func clickme(sender:UIButton!){
        let alert = UIAlertController(title: "Hi", message: "I am doudou", preferredStyle:.Alert)
        // Closure
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
            print("OK")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler:abcd))
        presentViewController(alert, animated: true, completion: nil)
    }
    func abcd(action: UIAlertAction!) {
         print("Cancel")
    }
}





