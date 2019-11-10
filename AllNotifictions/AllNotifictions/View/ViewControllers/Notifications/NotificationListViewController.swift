//
//  NotificationListViewController.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 11/10/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NotificationListViewController: UIViewController {
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var serviceFetchedResultsController: NSFetchedResultsController<NotificationHost>!
    var notificationFetchedResultsController: NSFetchedResultsController<Notification>!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSavedServices()
        
        fetchNotifications()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.hidesBackButton = true
        if let services = serviceFetchedResultsController.fetchedObjects {
            print(services.count)
            for service in services {
                if service.isLoggedIn {
                    switch service.title {
                    case "WordPress":
                        print("WordPress")
                        //TO DO: handle the force unwrapping better
                        WordpressAPIClient.getNotifications(token: service.token!, host: service) { (success, error) in
                            if success {
                                print("yay")
                                self.tableView.reloadData()
                            }
                        }
                    default:
                        print("break")
                        break
                    }
                    
                }
            }
        }
    }
    
    fileprivate func fetchSavedServices() {
        let serviceFetchRequest: NSFetchRequest<NotificationHost> = NotificationHost.fetchRequest()
        serviceFetchRequest.sortDescriptors = [NSSortDescriptor(key: "objectID", ascending: true)]
        serviceFetchedResultsController = NSFetchedResultsController(fetchRequest: serviceFetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: "service")
        do {
            try serviceFetchedResultsController.performFetch()
        } catch {
            print("Could not fetch services")
        }
    }
    
    fileprivate func fetchNotifications() {
        let notificationFetchRequest: NSFetchRequest<Notification> = Notification.fetchRequest()
        notificationFetchRequest.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: true)]
        notificationFetchedResultsController = NSFetchedResultsController(fetchRequest: notificationFetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: "notification")
        
        do {
            try notificationFetchedResultsController.performFetch()
            
        } catch {
            print("Could not fetch notifications")
        }
    }
    
}

extension NotificationListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var noteCount = 0
        if let fetchedNotes = notificationFetchedResultsController.fetchedObjects {
            noteCount = fetchedNotes.count
        }
        
        return noteCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: constants.notificationCellIdentifier, for: indexPath) as! NotificationCell
        
        cell.titleLabel.text = "TITLE"
        
        return cell
    }
    
    
}

extension NotificationListViewController {
    enum constants {
        static let notificationCellIdentifier = "notificationCell"
    }
}
