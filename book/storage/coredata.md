# Core Data

行百里者半九十
        import UIKit
        import CoreData

        @UIApplicationMain
        class AppDelegate: UIResponder, UIApplicationDelegate {
            var window: UIWindow?
            func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
                let dataHelper = DataHelper(context: self.managedObjectContext)
                dataHelper.seedDataStore()
                window?.rootViewController  = UIViewController()
                return true
            }
            func applicationWillTerminate(_ application: UIApplication) {
                self.saveContext()
            }
            lazy var applicationDocumentsDirectory: URL = {
                // The directory the application uses to store the Core Data store file. This code uses a directory named "com.andrewcbancroft.Zootastic" in the application's documents Application Support directory.
                let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                return urls[urls.count-1]
            }()
            internal var managedObjectModel: NSManagedObjectModel {
                let model = NSManagedObjectModel()
                let entity = NSEntityDescription()
                entity.name = "Zoo"
                var properties = Array<NSAttributeDescription>()
                let remoteURLAttribute = NSAttributeDescription()
                remoteURLAttribute.name = "name"
                remoteURLAttribute.attributeType = .stringAttributeType
                remoteURLAttribute.isOptional = false
                remoteURLAttribute.isIndexed = true
                properties.append(remoteURLAttribute)
                entity.properties = properties
                model.entities = [entity]
                return model
            }
            lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
                // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
                // Create the coordinator and store
                let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
                let url = self.applicationDocumentsDirectory.appendingPathComponent("Zootastic.sqlite")
                
                do {
                    try FileManager.default.removeItem(at: url)
                } catch _ {
                }
                var failureReason = "There was an error creating or loading the application's saved data."
                do {
                    try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
                } catch {
                    // Report any error we got.
                    var dict = [String: AnyObject]()
                    dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
                    dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
                    
                    dict[NSUnderlyingErrorKey] = error as NSError
                    let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
                    // Replace this with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
                    abort()
                }
                return coordinator
            }()
            
            lazy var managedObjectContext: NSManagedObjectContext = {
                // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
                let coordinator = self.persistentStoreCoordinator
                var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
                managedObjectContext.persistentStoreCoordinator = coordinator
                return managedObjectContext
            }()
            
            // MARK: - Core Data Saving support
            
            func saveContext () {
                if managedObjectContext.hasChanges {
                    do {
                        try managedObjectContext.save()
                    } catch {
                        // Replace this implementation with code to handle the error appropriately.
                        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        let nserror = error as NSError
                        NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                        abort()
                    }
                }
            }
        }
        public class DataHelper {
            let context: NSManagedObjectContext
            public init(context: NSManagedObjectContext) {
                self.context = context
            }
            public func seedDataStore() {
                seedZoos()
                
            }
            public func seedZoos() {
                let zoos = [
                    (name: "Oklahoma City Zoo", location: "Oklahoma City, OK"),
                    (name: "Lowry Park Zoo", location: "Tampa, FL"),
                    (name: "San Diego Zoo", location: "San Diego, CA")
                ]
                for zoo in zoos {
                    let a =  NSEntityDescription.insertNewObject(forEntityName: "Zoo", into: context)
                    //            let newZoo = a as! Zoo
                    a.setValue(zoo.name, forKey:"name")
                    //            newZoo.name = zoo.name
                    
                }
                do {
                    try context.save()
                } catch _ {
                }
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Zoo")
                //        fetchRequest.predicate = NSPredicate(format: "notificationId = 13")
                
                do {
                    let list = try context.fetch(fetchRequest) as? [NSManagedObject]
                    print(list!.count)
                    for zoo in list! {
                        print(zoo.value(forKey: "name")!)
                    }
                } catch let error as NSError {
                    // failure
                    print("Fetch failed: \(error.localizedDescription)")
                }
            }
            
        }
