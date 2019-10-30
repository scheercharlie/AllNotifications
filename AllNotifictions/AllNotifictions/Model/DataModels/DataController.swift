//
//  DataController.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 10/29/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    static let shared = DataController(modelName: "AllNotifications")
    
    private init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    let persistentContainer: NSPersistentContainer!
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    var backgroundContext: NSManagedObjectContext!
    
    func configureContexts(){
        backgroundContext = persistentContainer.newBackgroundContext()
        
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else {
                fatalError("Could not load persistent store")
            }
            self.configureContexts()
            completion?()
        }
    }
}
