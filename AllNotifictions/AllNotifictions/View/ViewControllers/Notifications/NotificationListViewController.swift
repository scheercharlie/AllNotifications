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

    @IBAction func loginWasTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: AppConstants.loginStoryboard, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(identifier: AppConstants.loginListVCIdentifier)
        
        present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSavedServices()
        
        fetchNotifications()
        
        activityView.hidesWhenStopped = true
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let services = serviceFetchedResultsController.fetchedObjects {
            startAnimatingAcitivityIndicator(true)
            for service in services {
                if service.isLoggedIn {
                    switch service.title {
                    case "WordPress":
                        fetchWordpressNotifications(service)
                    case "Github":
                        fetchGithubNotifications(service)
                    default:
                        print("break")
                        break
                    }
                    
                }
            }
            startAnimatingAcitivityIndicator(false)
        }
    }
    
    fileprivate func startAnimatingAcitivityIndicator(_ bool: Bool) {
        if bool {
            activityView.startAnimating()
            view.isUserInteractionEnabled = false
        } else {
            activityView.stopAnimating()
            view.isUserInteractionEnabled = true
        }
    }
    
    fileprivate func fetchWordpressNotifications(_ service: NotificationHost) {
        //TO DO: handle the force unwrapping better
        WordpressAPIClient.getNotifications(token: service.token!, host: service) { (success, error) in
            if success {
                self.tableView.reloadData()
                service.lastUpdated = Date()
                try? DataController.shared.viewContext.save()
            }
        }
    }
    
    fileprivate func fetchGithubNotifications(_ service: NotificationHost) {
        var dateString = ""
        
        if service.lastUpdated == nil {
            let date = Date(timeIntervalSince1970: TimeInterval(exactly: 10.0)!)
            let converter = ISO8601DateFormatter()
            let string = converter.string(from: date)
            dateString = string
        } else {
            if let date = service.lastUpdated {
                let converter = ISO8601DateFormatter()
                let string = converter.string(from: date)
                dateString = string
            }
        }
        
        GithubAPIClient.getNotifications(token: service.token!, host: service, since: dateString ) { (success, error) in
            if success{
                print("github yay")
                service.lastUpdated = Date()
                do {
                    try DataController.shared.viewContext.save()
                    try self.notificationFetchedResultsController.performFetch()
                    self.tableView.reloadData()
                    print("did save")
                } catch {
                    print("Couldn't save WordPress notifications")
                    
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
        notificationFetchRequest.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: false)]
        notificationFetchedResultsController = NSFetchedResultsController(fetchRequest: notificationFetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: "notification")
        
        do {
            try notificationFetchedResultsController.performFetch()
            print("count")
            print(notificationFetchedResultsController.fetchedObjects?.count)
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
            print("rows in section \(fetchedNotes.count)")
        }
        
        
        return noteCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: constants.notificationCellIdentifier, for: indexPath) as! NotificationCell
        
        guard let fetchedNotifications = notificationFetchedResultsController.fetchedObjects else {
            print("no fetched objects")
            return cell
        }
        
        //Fix github logo to work on not darkmode
        
        let notificationAtIndexPath = fetchedNotifications[indexPath.row]
        cell.titleLabel.text = notificationAtIndexPath.title
        cell.notificationLabel.text = notificationAtIndexPath.body
        
        let servicetitle = notificationAtIndexPath.notificationsHost?.title
        
        let image = UIImage(named: servicetitle!)
        cell.logoImageView.image = image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
}

extension NotificationListViewController {
    enum constants {
        static let notificationCellIdentifier = "notificationCell"
    }
}
