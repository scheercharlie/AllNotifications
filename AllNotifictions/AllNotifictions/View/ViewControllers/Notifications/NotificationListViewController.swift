//
//  NotificationListViewController.swift
//  AllNotifictions
//
//  Created by Charlie Scheer on 11/10/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation
import UIKit

class NotificationListViewController: UIViewController {
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.hidesBackButton = true
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
