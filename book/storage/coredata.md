# Core Data

行百里者半九十


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
                
                let zoos = [
                    (item: "Item 1",descriptor:""),
                    (item: "Item 2" ,descriptor:""),
                    (item: "Item 3",descriptor:"")
                ]
                for zoo in zoos {
                    let a =  NSEntityDescription.insertNewObject(forEntityName: "todo", into: context)
                    a.setValue(zoo.item, forKey:"item")
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
                        print(zoo.value(forKey: "item")!)
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
