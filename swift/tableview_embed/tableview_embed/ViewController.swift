//
//  ViewController.swift
//  tableview_embed
//
//  Created by quota on 2/1/16.
//  Copyright © 2016 liu. All rights reserved.
//

import UIKit
// 通过 UIView: 需要自己设置实现协议UITableViewDataSource，设置 dataSource
class ViewController1: UIViewController ,UITableViewDataSource{
    override func viewDidLoad() {
        super.viewDidLoad()
        let a  = UITableView()
        a.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        a.frame = CGRectMake(0,100,200,150)
        self.view.addSubview(a)
        self.view.backgroundColor = UIColor.redColor()
        a.dataSource = self
//        self.addChildViewController(a)
//        self.didMoveToParentViewController(a)
    }
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let MyIdentifier = "cell"
        var a = tableView.dequeueReusableCellWithIdentifier(MyIdentifier)
        if (a == nil){
            a = UITableViewCell(style: .Default, reuseIdentifier: MyIdentifier)
        }
        a!.backgroundColor = UIColor.greenColor()
        a!.textLabel?.text = "1"
        a!.detailTextLabel?.text = "1"
        return a!
    }

    
}
// 通过 ViewController ： 
// UITableViewController，代码规整，两个VC分工合理，且不需要设置 dataSource，不必conforms to UITableViewDataSource
// 因为UITableViewController已经做了。

class mtb1 : UITableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let MyIdentifier = "cell"
        var a = tableView.dequeueReusableCellWithIdentifier(MyIdentifier)
        if (a == nil){
            a = UITableViewCell(style: .Default, reuseIdentifier: MyIdentifier)
        }
        //        let a =  UITableViewCell()
        a!.backgroundColor = UIColor.greenColor()
        a!.textLabel?.text = "1"
        a!.detailTextLabel?.text = "1"
        return a!
    }
}
class ViewController: UIViewController {
    var  a : UITableViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        let a  = mtb1()
        a.view.frame = CGRectMake(0,100,300,200)
        self.view.addSubview(a.view)
        self.view.backgroundColor = UIColor.redColor()
    }
}

/*


#view vs. viewcontroller

A view is an object that is drawn to the screen. It may also contain other views (subviews) that are inside it and move with it. Views can get touch events and change their visual state in response. Views are dumb, and do not know about the structure of your application, and are simply told to display themselves in some state.
A view controller is not drawable to the screen directly, it manages a group of view objects. View controllers usually have a single view with many subviews. The view controller manages the state of these views. A view controller is smart, and has knowledge of your application's inner workings. It tells the dumb view objects what to do and how to show themselves.
A view controller is the glue between your overall application and the screen. It controls the views that it owns according to the logic of your application.
dumb : 哑的，无说话能力的；不说话的，无声音的

The UIViewController class provides the infrastructure for managing the views of your iOS apps. A view controller manages a set of views that make up a portion of your app’s user interface. It is responsible for loading and disposing of those views, for managing interactions with those views, and for coordinating responses with any appropriate data objects. View controllers also coordinate their efforts with other controller objects—including other view controllers—and help manage your app’s overall interface.
You rarely create instances of the UIViewController class directly. Instead, you create instances ofUIViewController subclasses and use those objects to provide the specific behaviors and visual appearances that you need.
A view controller’s main responsibilities include the following:
Updating the contents of the views, usually in response to changes to the underlying data.
Responding to user interactions with views.
Resizing views and managing the layout of the overall interface.
A view controller is tightly bound to the views it manages and takes part in the responder chain used to handle events. View controllers are also UIResponder objects and are inserted into the responder chain between the view controller’s root view and that view’s superview, which typically belongs to a different view controller. If none of the view controller’s views handle an event, the view controller has the option of handling the event or passing it along to the superview.
View controllers are rarely used in isolation. Instead, you often use multiple view controllers, each of which owns a portion of your app’s user interface. For example, one view controller might display a table of items while a different view controller displays the selected item from that table. Usually, only the views from one view controller are visible at a time. A view controller may present a different view controller to display a new set of views, or it may act as a container for other view controllers’ content and animate views however it wants.

View controllers are the foundation of your app’s internal structure. Every app has at least one view controller, and most apps have several. Each view controller manages a portion of your app’s user interface as well as the interactions between that interface and the underlying data. View controllers also facilitate transitions between different parts of your user interface.
Because they play such an important role in your app, view controllers are at the center of almost everything you do. The UIViewController class defines the methods and properties for managing your views, handling events, transitioning from one view controller to another, and coordinating with other parts of your app. You subclass UIViewController (or one of its subclasses) and add the custom code you need to implement your app’s behavior.
There are two types of view controllers:
Content view controllers manage a discrete piece of your app’s content and are the main type of view controller that you create.
Container view controllers collect information from other view controllers (known as child view controllers) and present it in a way that facilitates navigation or presents the content of those view controllers differently.Most apps are a mixture of both types of view controllers

A content view controller is a subclass of UIViewController that manages a single screen inside your iOS app. It has a view property that is the main view for that screen and gets messages and events for that screen. There are also container view controllers which contain one or more content view controllers. See Creating Custom Content View Controllers

If, for example, you have an application with two screens, one for a list of items and then one for detailed item information, your app will have at least two content view controller classes, one for the list of items screen and one for the detailed item information screen.

The mapping isn't exactly one view controller per screen - on iPads and wider iPhones you can sometimes have multiple view controllers in use simultaneously, often with a UISplitViewController controlling two sub-controllers.

*/