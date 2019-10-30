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
        
    }

    @IBAction func skipWasTapped(_ sender: Any) {
        
    }
    
}

extension LoginListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: constants.cellIdentifier, for: indexPath) as! LoginCell
        
        tableCell.serviceLogoImage.image = UIImage(named: "not-found")
        tableCell.loggedInCheckBoxImage.alpha = 0
        tableCell.serviceTitleLabel.text = "WordPress"
        
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! LoginCell
        
        cell.loggedInCheckBoxImage.alpha = 1
    }
    
    
}

extension LoginListViewController {
    enum constants {
        static let cellIdentifier = "loginCell"
    }
}
