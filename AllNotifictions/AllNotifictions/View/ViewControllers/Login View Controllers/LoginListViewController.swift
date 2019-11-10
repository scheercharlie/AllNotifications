//
//  ViewController.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 10/29/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit
import CoreData

class LoginListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var fetchedResultsController: NSFetchedResultsController<NotificationHost>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request: NSFetchRequest<NotificationHost> = NotificationHost.fetchRequest()
        let sortDescriptor = NSSortDescriptor.init(key: "objectID", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: DataController.shared.backgroundContext, sectionNameKeyPath: nil, cacheName: "service")
        do {
            try fetchedResultsController.performFetch()
        } catch {
            //TO DO: Handle the error better
            print("Fetch failed")
        }
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    @IBAction func skipWasTapped(_ sender: Any) {
        
    }
    
    
    
}

extension LoginListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let fetchedObjects = fetchedResultsController.fetchedObjects else {
            print("Could not fetch objects")
            return 0
        }
        
        return fetchedObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: constants.cellIdentifier, for: indexPath) as! LoginCell
        let service = fetchedResultsController.object(at: indexPath)
        
        if let title = service.title, let logo = UIImage(named: title) {
            tableCell.serviceLogoImage.image = logo
        } else {
            tableCell.serviceLogoImage.image = UIImage(named: constants.noLogoFound)
        }
        
        if service.isLoggedIn {
            tableCell.loggedInCheckBoxImage.alpha = 1
            tableCell.isUserInteractionEnabled = false
        } else {
            tableCell.loggedInCheckBoxImage.alpha = 0
        }
        
        if let title = service.title {
            tableCell.serviceTitleLabel.text = title
        }
        
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == constants.loginSegueIdentifier {
            let cell = sender as! LoginCell
        
            if let index = tableView.indexPath(for: cell) {
                let selectedService = fetchedResultsController.object(at: index)
                let destination = segue.destination as! LoginWebViewController
                destination.selectedService = selectedService
            } else {
                //Print error
                //Display alert: Login failed
            }
            
        }
    }
    
}

extension LoginListViewController {
    enum constants {
        static let cellIdentifier = "loginCell"
        static let noLogoFound = "not-found"
        static let loginSegueIdentifier = "segueToLogin"
    }
}
