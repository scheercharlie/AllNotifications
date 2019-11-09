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
        
        DataController.shared.load {
            print("Persistent Container load successful")
        }
        
        //Prepare a fetched results controller for NotificationHosts
        //If all of the Host options do not exist create them.
        let fetchedResultsController = prepareFetchedResultsController()
        if let fetchedObjects = fetchedResultsController.fetchedObjects, fetchedObjects.count != HostType.SocialService.allCases.count {
            createHostTypeObjects()
            
            if DataController.shared.viewContext.hasChanges {
                do {
                    try DataController.shared.viewContext.save()
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
        
        frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: "service")
        
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
            let newService = NotificationHost(context: DataController.shared.viewContext)
            let hostType = HostType(type: service)
            newService.setDataFromType(hostType)
            newService.isLoggedIn = false
            newService.title = hostType.getHostTitle()

        }
    }
    
    func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        print("will continue was called")
        
        return true
    }
    
}

