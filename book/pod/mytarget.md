我不是零基础开学的，而是之前有dotnet基础的人。但是我愿意分享下我的经历。
2015年，我也去看了下objc，第一感觉很不好，C语言和objc的扩展在一起，特别混乱，当时感觉：
1. 都是函数，C的函数和objc的函数创建和使用差别很大，并且混合在一起
2. objc函数带着参数标签的，函数长的受不了
3. 即使是第一步最小的app，也得了解设计模式，它一开始就出场，叫做delegate
所以我认为objc语言比较原始，没有随着大流和其他语言一起演进，暴得大名，其实不符。加上UIKit的封装做的比较差。写了个小app后，我随即放弃。
等到swift出来，2016年初，我略看了下，感觉好多了，好歹语言显得和主流的毕竟接近。而且还有类似脚本的强大的对象字面量，于是开始真的学习。坎和objc相比，少了语言的障碍，但是：
1. UIKit的函数名依然带标签，依然比较长，你可以感受下AppDelegate的第一个函数：
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool 
2. 依然需要了解设计模式，首先还是delegate，MVC。满篇的ViewController。
但是我还是学了。写了一些笔记都在github上。当时找了7-8本书，感觉太啰嗦，充斥者和当前要了解的东西不直接相关的内容，以及大量的和Storyboard相关操作的截图。这些截图让我心烦。我好歹是一个程序员啊，写代码看代码，跑代码，不好吗。看什么图，又不是学PS。
2017年，我决定把这个事儿捡起来，我的做法是上来直接看Apple的开发者文档。当然，难度肯定是有，毕竟这个东西是面向UIKit本身的，讲究的是说明白本身，而且一贯的，官方文档的例子都比较少。我看了这个文档中的UIKit，Foundation部分，看了很多遍。看了当天就要笔记，笔记保证都是有一个自己编写的可以跑得通的案例。这个案例必须一次粘贴到IDE内，然后就可以RUN。一个个控件的做下来，并且发布在掘金上。确实看不懂，查了google和SO也没有结果的，就打印出来，反反复复的看。

这时候我觉得脑袋里面已经都是知识了，要爆了，必须得输出了。我然后又找了一个App，是开源的swift编写的v2ex客户端，Finb/V2ex-Swift。我翻了几个app，觉得这个代码写的相对简单，规整，访问的论坛我也比较熟悉，于是决定从它这里，再来一遍我的所学，印证下我的知识。这个app除了代码比较清洁，结构简单外，也有用了不少第三方的包。比如上拉下拉控件，1password扩展，Keychain扩展，alamafire网络扩展等开发一个App几乎必备的包，可以一并学习。
地址在此：TofJ 的个人主页 - 掘金，不知不觉的，居然积累了40篇了。在掘金写博客3月，骗了1500的关注呢。我一直秉承几个原则：
1. 说什么就集中说什么，和当前要关心的无关的，不谈
2. 代码贴入IDE，覆盖AppDelegate.swift，然后就可以RUN，保证能跑，不需要你在文章里面七拼八凑的
3. 坚持用代码，不用StoryBoard。用了SB，就直接进入截图党，操作员，一张图细节太多，但是看过了，就毫无内容。我不反对使用SB做设计，但是极为反对使用SB来学习UIKit的UI设计

我在阅读Finb/V2ex-Swift代码中，也在按自己的想法做了一些重构：
1. 大意是提炼公共代码，把代码搬来搬去的放在更加合适的地方，封装了简单的基础类，比如TableView，这个最常用的控件的封装。
2. 当然，我一直反对使用delegate，而是想要转换它为Property-Method-Event的模式，所以封装的底层当然还是delegate，高层就尽可能引入Event。
3. 在有些地方为了充分理解，可能需要抽取ViewController代码到单独的工程中来做验证。这个做法，让我吃了不少苦头。就是说你抽了ViewController，随即它的七大姑八大姨也跟着来，大家都是耦合在一起的。为了以后我做这个工作简单，我使用消息机制，把所有的ViewController的全部打破，原来的互相耦合，全部通过一个中心类，通过消息发送和接收处理变成了单纯的星型耦合。
我把我的工作放到了这里。1000copy/fin 。这里的代码基于Finb的贡献，感谢他的分享。这个代码我希望它更好阅读，也更好拆分，分而治之。
对Swift的学习依然继续。我希望为它做出一个框架，有了这个框架Swift就像C#一样好用。
