//
//  AppDelegate.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 10/29/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Prepare a fetched results controller for NotificationHosts
        //If all of the Host options do not exist create them.
        let fetchedResultsController = prepareFetchedResultsController()
        if let fetchedObjects = fetchedResultsController.fetchedObjects, fetchedObjects.count != HostType.SocialService.allCases.count {
            createHostTypeObjects()
            
            if persistentContainer.viewContext.hasChanges {
                do {
                    try persistentContainer.viewContext.save()
                } catch {
                    print("Save Failed")
                }
            }
        }
        

        return true
    }
    
    //Prepares a fetched results controller to make sure the app contains the Host Objects
    fileprivate func prepareFetchedResultsController() -> NSFetchedResultsController<NotificationHost> {
        let request: NSFetchRequest<NotificationHost> = NotificationHost.fetchRequest()
        let sortDescriptor = NSSortDescriptor.init(key: "objectID", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        var frc = NSFetchedResultsController<NotificationHost>()
        
        frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: "service")
        
        do {
            try frc.performFetch()
        } catch {
            //TO DO: Handle the fatelError better
            fatalError()
        }
        
        return frc
    }
    
    //Create new host objects
    fileprivate func createHostTypeObjects() {
        for service in HostType.SocialService.allCases {
            switch service {
            case .github:
                let github = NotificationHost(context: persistentContainer.viewContext)
                github.hostType?.type = service
                github.isLoggedIn = false
            case .wordpress:
                let wordpress = NotificationHost(context: persistentContainer.viewContext)
                wordpress.hostType?.type = service
                wordpress.isLoggedIn = false
            case .slack:
                let slack = NotificationHost(context: persistentContainer.viewContext)
                slack.hostType?.type = service
                slack.isLoggedIn = false
            }
        }
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "AllNotifictions")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

