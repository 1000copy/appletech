## 目标

本地化的意义，在于iOS切换不同语言时，App可以随同改变，用指定的语言显示应用。iOS提供了一套用来国际化的工具。本文就来解析它。

希望是代码传入一个字符串，在不同语言情况下，显示不同内容。具体说：

    print (NSLocalizedString("Welcome", comment: "Welcome"))
    
在语言为英语是，可以打印出：
    
    Welcome english

在语言为汉语时，可以打印出：
    
    欢迎 zh-Hans
    
## 准备工程和字符串文件

我们先干起来。第一步是创建一个Single View app的工程。然后首先进入工程目录，随即执行如下命令，创建用于不同语言的字符串文件：

    mkdir Base.lproj 
    touch Base.lproj/Localizable.strings
    echo '"Welcome" = "welcome base";' > Base.lproj/Localizable.strings
    mkdir en.lproj
    touch en.lproj/Localizable.strings
    echo '"Welcome" = "Welcome english";' > en.lproj/Localizable.strings
    mkdir zh-Hans.lproj
    touch zh-Hans.lproj/Localizable.strings
    echo '"Welcome" = "欢迎 zh-Hans";' > zh-Hans.lproj/Localizable.strings

这样，zh-Hans.lproj/Localizable.strings的内容,使用`cat zh-Hans.lproj/Localizable.strings`可以看出是:

    "Welcome" = "欢迎 zh-Hans";

引号很重要，分号也很重要，写错了，就玩不出来了。`.strings`类的文件目的就是为了建立字符串和本地文字的关系，只是改变语言后可以变化的数据基础。

文件有了，下面是把它们加入工程，做法就是选择工程，点击鼠标右键，点击菜单`add files to `,多选文件目录清单为：

    Base.lproj
    en.lproj
    zh-Hans.lproj
    
## 终于到代码

随即，粘贴代码到

    import UIKit
    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {
        var window: UIWindow?
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            print (NSLocalizedString("Welcome", comment: "Welcome"))
            return true
        }
    }

执行，如果你此时的模拟器使用的语言为中文的话，那么应该可以看到如下内容打印在控制台：

    欢迎 zh-Hans
    
一个本地化，不外乎是字符串对应表，然后查表的操作，水果公司也能搞得这么复杂，我也是服了。