# Core Data

Core Data是官方对Sqlite访问的封装框架。使用它的好处是：

1. 不需要自己引入Sqlite动态库和创建桥接文件
2. 不需要使用SQL语言即可访问Sqlite

使用它的首要需求是引入它，像是这样：

        import CoreData

依然假设我们的问题是存储todo项目，字段为id、item，希望创建数据库、创建表、插入数据、查询数据一气呵成，代码如下：

        import UIKit
        import CoreData

        @UIApplicationMain
        class AppDelegate: UIResponder, UIApplicationDelegate {
            var window: UIWindow?
            var context :NSManagedObjectContext!
            func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
                let dbname = "foo.bar"
                // section : model
                let model = NSManagedObjectModel()
                let entity = NSEntityDescription()
                entity.name = "todo"
                var properties = Array<NSAttributeDescription>()
                let idAttr = NSAttributeDescription()
                idAttr.name = "id"
                idAttr.attributeType = .integer64AttributeType
                idAttr.isOptional = false
                idAttr.isIndexed = true
                properties.append(idAttr)
                let itemAttr = NSAttributeDescription()
                itemAttr.name = "item"
                itemAttr.attributeType = .stringAttributeType
                itemAttr.isOptional = false
                itemAttr.isIndexed = true
                properties.append(itemAttr)
                entity.properties = properties
                model.entities = [entity]
                
                // section : coordinator
                let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
                let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                let docURL = urls[urls.count-1]
                let url = docURL.appendingPathComponent(dbname)
                
                do {
                    try FileManager.default.removeItem(at: url)
                } catch _ {
                }
                do {
                    try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
                } catch {
                    print("caught: \(error)")
                    abort()
                }
                //section : context
                context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
                context.persistentStoreCoordinator = coordinator
                // section : app code
                
                let todos = [
                    (item: "Item 1",id:1),
                    (item: "Item 2" ,id:2),
                    (item: "Item 3",id:3)
                ]
                for todo in todos {
                    let a =  NSEntityDescription.insertNewObject(forEntityName: "todo", into: context)
                    a.setValue(todo.item, forKey:"item")
                    a.setValue(todo.id, forKey:"id")
                }
                do {
                    try context.save()
                } catch _ {
                }
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"todo")
                //        fetchRequest.predicate = NSPredicate(format: "notificationId = 13")
                
                do {
                    let list = try context.fetch(fetchRequest) as? [NSManagedObject]
                    print(list!.count)
                    for zoo in list! {
                        print(zoo.value(forKey: "item")!,zoo.value(forKey: "id")!)
                    }
                } catch let error as NSError {
                    // failure
                    print("Fetch failed: \(error.localizedDescription)")
                }
                window?.rootViewController  = UIViewController()
                return true
            }
            func applicationWillTerminate(_ application: UIApplication) {
                if context.hasChanges {
                    do {
                        try context.save()
                    } catch {
                        print("caught: \(error)")
                        abort()
                    }
                }
            }
        }

完成要求的一系列的动作的过程中，首先我们来看创建数据库的模型，也就是标注为：
        
        // section : model

开始的代码，它使用了如下的类：

1. NSManagedObjectModel
2. NSEntityDescription
3. NSAttributeDescription

既然是对Sqlite的封装，那么这些类显然分别对应于数据库、表、字段的。所以尽管代码看起来有些冗长，意图倒是比较明显的。它们等同于创建这样的表：

        表名：todo
        表字段清单：
            名字  类型 可选 索引
            id   int64 否  是
            item string否  是

此处的代码只是创建了一个内存中的模型，真正的创建使用了NSPersistentStoreCoordinator，在标注为：

        // section : coordinator
开始的代码中进行。NSPersistentStoreCoordinator用来把模型和真实的存储关联起来。代码中对FileManager的引用的目的就是在文件存储中关联一个文件，如果存在就会删除它。接下来的NSManaged​Object​Context可以调用它的save()方法，把当前上下文的数据存储起来，也可以使用fetch方法，通过NSFetchRequest指定表名和条件来查询数据。如果需要插入数据，则需要使用NSEntityDescription的insertNewObject()方法。

这只是一个案例，真正的应用有可能正在编辑数据时，App被退出，那么数据将不能被保存。如果需要在退出前保存的话，需要在：

        func applicationWillTerminate(_ application: UIApplication)     

检测变化，并调用NSManaged​Object​Context.save()来保存数据。



