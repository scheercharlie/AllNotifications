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

    //MARK: Life cycle methods
    //Present Login view if user wants to log into more sources
    @IBAction func loginWasTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: AppConstants.loginStoryboard, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(identifier: AppConstants.loginListVCIdentifier)
        
        present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityView.hidesWhenStopped = true
        
        fetchSavedServices()
        fetchNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //Fetch new notifications
        if let services = serviceFetchedResultsController.fetchedObjects {
            startAnimatingAcitivityIndicator(true)
            
            //For each service, if logged in try to fetch new notifications
            for service in services {
                if service.isLoggedIn {
                    switch service.title {
                    case "WordPress":
                        fetchWordpressNotifications(service)
                    case "Github":
                        fetchGithubNotifications(service)
                    default:
                        break
                    }
                    
                }
            }
            startAnimatingAcitivityIndicator(false)
        }
    }
    
    //Start activity indicator while downloading and disable user interaction
    //True begins animation and disables interaction
    //False stops animation and restores interaction
    fileprivate func startAnimatingAcitivityIndicator(_ bool: Bool) {
        if bool {
            activityView.startAnimating()
            view.isUserInteractionEnabled = false
        } else {
            activityView.stopAnimating()
            view.isUserInteractionEnabled = true
        }
    }
    
    //MARK: Fetch notifications from API Methods
    //Fetch notifications for WordPress.com
    fileprivate func fetchWordpressNotifications(_ service: NotificationHost) {
        WordpressAPIClient.getNotifications(token: service.token!, host: service) { (success, error) in
            if success {
                self.tableView.reloadData()
                
                //Update when WordPress was last updated
                service.lastUpdated = Date()
                DataController.shared.saveViewContext()
            } else {
                self.displayNoActionAlert(title: "Connection Failure", message: "Could not get notifications from WordPress.  Please try again later!")
            }
        }
    }
    
    //Fetch notifications for Github
    fileprivate func fetchGithubNotifications(_ service: NotificationHost) {
        var dateString = ""
        
        //if there is not a saved notification date for Github, create one back in the past and download all notifications
        if service.lastUpdated == nil {
            let date = Date(timeIntervalSince1970: TimeInterval(exactly: 10.0)!)
            let converter = ISO8601DateFormatter()
            let string = converter.string(from: date)
            dateString = string
        } else {
            //If there is a saved update date, set dateString to last update
            if let date = service.lastUpdated {
                let converter = ISO8601DateFormatter()
                let string = converter.string(from: date)
                dateString = string
            }
        }
        
        //Fetch notifications from Github based on since date
        GithubAPIClient.getNotifications(token: service.token!, host: service, since: dateString ) { (success, error) in
            if success{
                service.lastUpdated = Date()
                do {
                    try DataController.shared.viewContext.save()
                    try self.notificationFetchedResultsController.performFetch()
                    self.tableView.reloadData()
                } catch {
                    print("Couldn't save WordPress notifications")
                    
                }
            } else {
                self.displayNoActionAlert(title: "Connection Failure", message: "Could not get notifications from Github.  Please try again later!")
            }
        }
    }
    
    //MARK: Core data fetch methods
    //Get saved notifications hosts from core data
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
    
    //Get saved notifications from Core data
    fileprivate func fetchNotifications() {
        let notificationFetchRequest: NSFetchRequest<Notification> = Notification.fetchRequest()
        notificationFetchRequest.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: false)]
        notificationFetchedResultsController = NSFetchedResultsController(fetchRequest: notificationFetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: "notification")
        
        do {
            try notificationFetchedResultsController.performFetch()
        } catch {
            print("Could not fetch notifications")
        }
    }

}

//MARK: TableView delegate and data source methods
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


//MARK: View Constants
extension NotificationListViewController {
    enum constants {
        static let notificationCellIdentifier = "notificationCell"
    }
}
