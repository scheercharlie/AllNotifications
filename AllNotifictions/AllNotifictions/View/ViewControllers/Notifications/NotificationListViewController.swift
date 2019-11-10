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
    
    var serviceFetchedResultsController: NSFetchedResultsController<NotificationHost>!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSavedServices()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.hidesBackButton = true
    }
    
    fileprivate func fetchSavedServices() {
        let serviceFetchRequest = NSFetchRequest<NotificationHost>()
        serviceFetchRequest.sortDescriptors = [NSSortDescriptor(key: "objectID", ascending: true)]
        serviceFetchedResultsController = NSFetchedResultsController(fetchRequest: serviceFetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: "service")
        do {
            try serviceFetchedResultsController.performFetch()
        } catch {
            print("Could not fetch services")
        }
    }
    
}

extension NotificationListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: constants.notificationCellIdentifier, for: indexPath) as! NotificationCell
        
        
        return cell
    }
    
    
}

extension NotificationListViewController {
    enum constants {
        static let notificationCellIdentifier = "notificationCell"
    }
}
