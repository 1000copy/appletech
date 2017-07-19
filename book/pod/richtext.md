通常给UILabel设置文本，我们都是设置属性UILabel.text。这意味着显示的文本是单一的，整个文本只能有一种同样的文本效果。而另外一个属性UILabel.attributedText，就可以可以分段设置的不同的字体、阴影效果等，比如前几个字为一个阴影效果，后几个字使用下划线效果。

如下代码我做了些改变，以便在Swift 3.0上可以运行，本来的代码来自 https://makeapppie.com/2016/07/05/using-attributed-strings-in-swift-3-0/ ，

可以运行起来，查看效果：

    import UIKit
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        var window: UIWindow?
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let page = Page()
            page.view.backgroundColor = .white
            self.window!.rootViewController = page
            self.window?.makeKeyAndVisible()
            return true
        }
    }
    class Page: UIViewController {
        
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let myLabel = UILabel()
            let myString = "P is for Pizza and Pizza is for me"
            
            view.backgroundColor = UIColor.white
            //initialize the label to be the entire view
            //and to word wrap
            
            myLabel.frame = view.bounds.insetBy(dx: 20, dy: 20)
            //mylabel.frame.size.width = 350.0//uncomment for playgrounds
            myLabel.lineBreakMode = .byWordWrapping
            myLabel.numberOfLines = 0
    //        myLabel.backgroundColor = UIColor.yellow
            myLabel.text = myString
            view.addSubview(myLabel)
            
            //: Initialize the mutable string
            let myMutableString = NSMutableAttributedString(
                string: myString,
                attributes: [NSFontAttributeName:
                    UIFont(name: "Georgia", size: 18.0)!])
            
            // for first Pizza
            myMutableString.addAttribute(
                NSFontAttributeName,
                value: UIFont(
                    name: "Chalkduster",
                    size: 24.0)!,
                range: NSRange(
                    location: 9,
                    length: 5))
            
            //: Make a big blue P
            myMutableString.addAttribute(
                NSFontAttributeName,
                value: UIFont(
                    name: "AmericanTypewriter-Bold",
                    size: 36.0)!,
                range: NSRange(
                    location:0,
                    length:1))
            myMutableString.addAttribute(
                NSForegroundColorAttributeName,
                value: UIColor.blue,
                range: NSRange(
                    location:0,
                    length:1))
            
            
            //: Make the second pizza red and outlined in Helvetica Neue
            myMutableString.addAttribute(
                NSFontAttributeName,
                value: UIFont(
                    name: "Helvetica Neue",
                    size: 36.0)!,
                range: NSRange(
                    location: 19,
                    length: 5))
            
            myMutableString.addAttribute(
                NSStrokeColorAttributeName,
                value: UIColor.red,
                range:  NSRange(
                    location: 19,
                    length: 5))
            
            myMutableString.addAttribute(
                NSStrokeWidthAttributeName,
                value: 4,
                range: NSRange(
                    location: 19,
                    length: 5))
            
            //: Set the background color is attributes text.
            //: which is not the color of the background text.
            let  stringLength = myString.characters.count
            myMutableString.addAttribute(NSBackgroundColorAttributeName,
                                         value: UIColor.magenta,
                                         range: NSRange(
                                            location: 0,
                                            length: stringLength))
            
            
            
            //: Add a Drop Shadow
            
            //: Make the Drop Shadow
            let shadow = NSShadow()
            shadow.shadowOffset = CGSize(width: 5, height: 5)
            shadow.shadowBlurRadius = 5
            shadow.shadowColor = UIColor.gray
            
            //: Add a drop shadow to the text
            myMutableString.addAttribute(
                NSShadowAttributeName,
                value: shadow,
                range: NSRange(
                    location: 27,
                    length: 7))
            
            //:Change to 48 point Menlo
            myMutableString.addAttribute(
                NSFontAttributeName,
                value: UIFont(
                    name: "Menlo",
                    size: 48.0)!,
                range: NSRange(
                    location: 27,
                    length: 7))
            
            //: Appending the String with !!! and an Attributed String
            let myAddedStringAttributes:[String:AnyObject]? = [
                NSFontAttributeName:UIFont(
                    name: "AvenirNext-Heavy",
                    size: 48.0)!,
                NSForegroundColorAttributeName:UIColor.red,
                NSShadowAttributeName: shadow
                
            ]
            let myAddedString = NSAttributedString(
                string: "!!!",
                attributes: myAddedStringAttributes)
            myMutableString.append(myAddedString)
            
            //: Apply to the label
            myLabel.attributedText = myMutableString
            
        }
        
    }

相当的具有表现力。